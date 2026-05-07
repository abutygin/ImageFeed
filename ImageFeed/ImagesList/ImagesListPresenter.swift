//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 05.05.2026.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    func onViewDidLoad()
    func willShowCell(at index: Int)
    func didTapLikeButton(at index: Int)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? = nil
    var photos: [Photo] = []
    let imagesListService: ImagesListServiceProtocol

    init(imagesListService: ImagesListServiceProtocol) {
        self.imagesListService = imagesListService
    }
    
    func onViewDidLoad() {
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
                self?.updatePhotos()
            })
        imagesListService.fetchPhotosNextPage()
    }

    func willShowCell(at index: Int) {
        if index + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }

    private func updatePhotos() {
        let oldCount = photos.count
        let newPhotos = imagesListService.photos
        photos = newPhotos

        if newPhotos.count != oldCount {
            let newCount = newPhotos.count
            let indexPaths = (oldCount..<newCount).map {
                IndexPath(row: $0, section: 0)
            }
            view?.insertRows(at: indexPaths)
        }
    }

    func didTapLikeButton(at index: Int) {
        let photo = photos[index]
        view?.showProgress()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            self.view?.hideProgress()
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let index = self.photos.firstIndex(where: { $0.id == photo.id}) {
                        let currentPhoto = self.photos[index]
                        let newPhoto = currentPhoto.toggleLike()
                        self.photos[index] = newPhoto
                        self.view?.updateImage(at: index)
                    }
                case .failure:
                    self.view?.showError("Что-то пошло не так")
                }
            }
        }
    }
}
