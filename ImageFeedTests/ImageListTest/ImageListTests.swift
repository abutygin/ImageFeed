//
//  ImageListTests.swift
//  ImageFeedTests
//
//  Created by ALEXANDER BUTYGIN on 07.05.2026.
//

@testable import ImageFeed
import XCTest

final class ImageListTests: XCTestCase {

    func testImagesListController() {
        // given
        let controller = ImagesListViewController()
        let presenterSpy = ImageListPresenterSpy()
        controller.configure(presenterSpy)

        // when
        _ = controller.view

        // then
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }

    func testImagesListPresenterCallFetch() {
        // given
        let imagesService = ImagesListServiceDouble()
        let presenter = ImagesListPresenter(imagesListService: imagesService)
        let controller = ImageListControllerSpy()
        presenter.view = controller

        // when
        presenter.onViewDidLoad()

        // then
        XCTAssertTrue(imagesService.photosFetched)
    }
}
