//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 03.04.2026.
//

import UIKit
import Kingfisher
import ProgressHUD

final class SingleImageViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!

    var imageUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        loadImage()
    }

    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapShareButton(_ sender: Any) {
        guard  let image = imageView.image else { return }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        imageView.frame = CGRect(origin: .zero, size: image.size)
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }

    private func loadImage() {
        guard let url = imageUrl else { return }
        UIBlockingProgressHUD.show()

        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }

            switch result {
            case .success(let value):
                let image = value.image
                self.rescaleAndCenterImageInScrollView(image: image)
            case .failure(let error):
                L.logger.error("Ошибка загрузки изображения \(error.localizedDescription)")
                self.showError()
            }
        }
    }

    private func showError() {
        let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Не надо", style: .cancel))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.loadImage()
        })
        present(alert, animated: true)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidEndZooming(
        _ scrollView: UIScrollView,
        with view: UIView?,
        atScale scale: CGFloat
    ) {
        let newContentSize = scrollView.contentSize
        let visibleRectSize = scrollView.bounds.size
        var topInset = (visibleRectSize.height - newContentSize.height) / 2
        if topInset < 0 {
            topInset = 0
        }
        var leftInset = (visibleRectSize.width - newContentSize.width) / 2
        if leftInset < 0 {
            leftInset = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset = UIEdgeInsets(top: topInset, left: leftInset, bottom: 0, right: 0)
        }
    }
}
