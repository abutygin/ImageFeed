//
//  ImageListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by ALEXANDER BUTYGIN on 07.05.2026.
//

@testable import ImageFeed
import Foundation

final class ImageListPresenterSpy: ImagesListPresenterProtocol {
    var viewDidLoadCalled = false
    var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []

    func onViewDidLoad() {
        viewDidLoadCalled = true
    }

    func willShowCell(at index: Int) {

    }
    func didTapLikeButton(at index: Int) {

    }
}
