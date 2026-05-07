//
//  StartScreen.swift
//  ImageFeedUITests
//
//  Created by ALEXANDER BUTYGIN on 06.05.2026.
//

import XCTest

class StartScreen: BaseScreen, Showable {
    private lazy var loginButton = app.buttons["Id.Authenticate"]

    func isShowing() -> Bool {
        return loginButton.isHittable
    }

    func tapLoginButton() {
        loginButton.tap()
    }
}
