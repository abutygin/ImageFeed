//
//  ImageListScreen.swift
//  ImageFeedUITests
//
//  Created by ALEXANDER BUTYGIN on 06.05.2026.
//

import XCTest

class ImageListScreen: BaseScreen, Showable {
    private lazy var firstCell = app.tables.cells.firstMatch

    func isShowing() -> Bool {
        return firstCell.isHittable
    }

    func tapLikeButton(index: Int = 0) {
        let cell = getCell(index: index)
        let likeButton = cell.buttons.firstMatch
        likeButton.tap()
    }

    func isImageLiked(index: Int = 0) -> Bool {
        let cell = getCell(index: index)
        let likeButton = cell.buttons.firstMatch
        return likeButton.label == "like on"
    }

    func tapImage(index: Int = 0) {
        let cell = getCell(index: index)
        cell.images.firstMatch.tap()
    }

    func getCell(index: Int = 0) -> XCUIElement {
        let cell = app.tables.cells.element(boundBy: index)
        return cell
    }

    func swipeUp() {
        let table = app.tables.firstMatch
        table.swipeUp()
    }

    func swipeDown() {
        let table = app.tables.firstMatch
        table.swipeDown()
    }
}
