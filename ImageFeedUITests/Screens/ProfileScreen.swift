//
//  ProfileScreen.swift
//  ImageFeedUITests
//
//  Created by ALEXANDER BUTYGIN on 06.05.2026.
//

import Foundation

class ProfileScreen: BaseScreen, Showable {
    private lazy var logoutButton = app.buttons[ElementIds.exitButton.rawValue]

    enum ElementIds: String {
        case exitButton
        case nameLabel
        case loginLabel
        case descriptionLabel
    }

    func isShowing() -> Bool {
        logoutButton.isHittable
    }

    func tapLogoutButton() {
        logoutButton.tap()
    }

    func getLabelText(_ textLabel: ElementIds) -> String {
        let textElement = app.staticTexts[textLabel.rawValue]
        return textElement.label
    }
}
