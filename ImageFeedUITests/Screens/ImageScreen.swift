//
//  ImageScreen.swift
//  ImageFeedUITests
//
//  Created by ALEXANDER BUTYGIN on 06.05.2026.
//

import Foundation

class ImageScreen: BaseScreen, Showable {
    private lazy var shareButton = app.buttons["id.ShareButton"]
    private lazy var image = app.scrollViews.images.firstMatch
    private lazy var navBackButtonWhiteButton = app.buttons["Id.BackButton"]
    
    func isShowing() -> Bool {
        return shareButton.isHittable
    }

    func zoomIn() {
        image.pinch(withScale: 3, velocity: 1)
    }

    func zoomOut() {
        image.pinch(withScale: 0.5, velocity: -1)
    }

    func tapBackButton() {
        navBackButtonWhiteButton.tap()
    }
}
