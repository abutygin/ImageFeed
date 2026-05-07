//
//  ImagesListServiceDouble.swift
//  ImageFeedTests
//
//  Created by ALEXANDER BUTYGIN on 07.05.2026.
//

@testable import ImageFeed
import Foundation

class ImagesListServiceDouble: ImagesListServiceProtocol {
    var photosFetched = false
    var photoLikeChanged = false

    private(set) var photos: [Photo] = []
    func fetchPhotosNextPage() {
        photosFetched = true
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        photoLikeChanged = true
    }
}
