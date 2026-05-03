//
//  ViewController.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 12.03.2026.
//

import UIKit

final class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!

    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var photos: [Photo] = []
    private lazy var imagesListService = ImagesListService.shared

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)

        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
                self?.updateTableViewAnimated()
            })
        imagesListService.fetchPhotosNextPage()

    }

    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
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

        let likeImage = photo.isLiked ? UIImage(named: "like_on") : UIImage(named: "like_off")
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
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            let photo = photos[indexPath.row]
            let url = URL(string: photo.largeImageURL)
            viewController.imageUrl = url
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
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
        let photo = photos[indexPath.row]
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
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLikeButton(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else {
                return
            }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let index = self.photos.firstIndex(where: { $0.id == photo.id}) {
                        let currentPhoto = self.photos[index]
                        let newPhoto = currentPhoto.toggleLike()
                        self.photos[index] = newPhoto
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                case .failure:
                    let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
