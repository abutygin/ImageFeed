//
//  OAuthScreen.swift
//  ImageFeedUITests
//
//  Created by ALEXANDER BUTYGIN on 06.05.2026.
//

import Foundation

class OAuthScreen: BaseScreen, Showable {
    private lazy var webView = app.webViews.webViews.webViews.firstMatch
    private lazy var loginTextField = webView.textFields.firstMatch
    private lazy var passwordTextField = webView.secureTextFields.firstMatch
    private lazy var loginButton = webView.buttons["Login"]
    private lazy var loginLabel = app.webViews.staticTexts["Login"]

    func isShowing() -> Bool {
        webView.isHittable && loginLabel.isHittable
    }

    func enterLogin(_ text: String) {
        loginTextField.tap()
        loginTextField.typeText(text)
    }

    func enterPassword(_ text: String) {
        passwordTextField.tap()
        passwordTextField.typeText(text)
    }

    func tapLoginButton() {
        loginButton.tap()
    }

    func tapBackButton() {

    }

    func closeKeyboard() {
        loginLabel.tap()
    }
}
