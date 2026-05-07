//
//  ImageScreen.swift
//  ImageFeedUITests
//
//  Created by ALEXANDER BUTYGIN on 06.05.2026.
//

import Foundation

class ImageScreen: BaseScreen, Showable {
    enum ElementIds: String {
        case shareButton = "id.ShareButton"
        case backButton = "Id.BackButton"
    }

    private lazy var shareButton = app.buttons[ElementIds.shareButton.rawValue]
    private lazy var image = app.scrollViews.images.firstMatch
    private lazy var navBackButton = app.buttons[ElementIds.backButton.rawValue]
    
    func isShowing() -> Bool {
        shareButton.isHittable
    }

    func zoomIn() {
        image.pinch(withScale: 3, velocity: 1)
    }

    func zoomOut() {
        image.pinch(withScale: 0.5, velocity: -1)
    }

    func tapBackButton() {
        navBackButton.tap()
    }
}
