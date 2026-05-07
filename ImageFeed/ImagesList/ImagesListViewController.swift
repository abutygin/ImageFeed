//
//  ViewController.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 12.03.2026.
//

import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
    func updateImage(at index: Int)
    func insertRows(at indexPaths: [IndexPath])
    func showError(_ message: String)
    func showProgress()
    func hideProgress()
}

final class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!

    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    var imageListPresenter: ImagesListPresenterProtocol?

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    func configure(_ presenter: ImagesListPresenterProtocol) {
        self.imageListPresenter = presenter
        self.imageListPresenter?.view = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageListPresenter?.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }

    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photo = imageListPresenter?.photos[indexPath.row] else {
            return
        }
        cell.showAnimation()
        guard let url = URL(string: photo.thumbImageURL) else {
            cell.cellImage.image = UIImage(named: "stub_image")
            cell.hideAnimation()
            return
        }
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "stub_image")
        ) { result in
            cell.hideAnimation()
            guard let currentIndexPath = self.tableView.indexPath(for: cell),
                  currentIndexPath == indexPath else {
                return
            }
        }
        cell.delegate = self

        let likeImage = UIImage(named: photo.isLiked ? "like_on" : "like_off")
        cell.likeButton.setImage(likeImage, for: .normal)
        if let date = photo.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: date)
        } else {
            cell.dateLabel.text = ""
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath,
                let photo = imageListPresenter?.photos[indexPath.row]
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            let url = URL(string: photo.largeImageURL)
            viewController.imageUrl = url
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: ImagesListViewControllerProtocol {
    func updateImage(at index: Int) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }

    func insertRows(at indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.tableView.performBatchUpdates {
                self.tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }

    func showProgress() {
        DispatchQueue.main.async {
            UIBlockingProgressHUD.show()
        }
    }

    func hideProgress() {
        DispatchQueue.main.async {
            UIBlockingProgressHUD.dismiss()
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imageListPresenter?.photos.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            L.logger.info("wrong type of cells")
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = imageListPresenter?.photos[indexPath.row] else {
            return 0.0
        }
        let imageWidth = photo.size.width
        let imageHeight = photo.size.height

        guard imageWidth > 0 else { return 0 }

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right

        let scale = imageViewWidth / imageWidth
        let cellHeight = imageHeight * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        imageListPresenter?.willShowCell(at: indexPath.row)
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLikeButton(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        imageListPresenter?.didTapLikeButton(at: indexPath.row)
    }
}
