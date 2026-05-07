//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by ALEXANDER BUTYGIN on 05.05.2026.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    let yourLogin = "<Ваш e-mail>"
    let yourPass = "<Ваш пароль>"

    private let app = XCUIApplication() // переменная приложения
    private lazy var startScreen = StartScreen()
    private lazy var oauthScreen = OAuthScreen()
    private lazy var imageListScreen = ImageListScreen()
    private lazy var imageScreen = ImageScreen()
    private lazy var profileScreen = ProfileScreen()
    
    override func setUpWithError() throws {
        continueAfterFailure = true // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так

        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        openStartScreen()
        startScreen.waitForShowing()
        startScreen.tapLoginButton()

        oauthScreen.waitForShowing()
        oauthScreen.enterLogin(yourLogin)
        oauthScreen.closeKeyboard()
        oauthScreen.enterPassword(yourPass)
        oauthScreen.closeKeyboard()
        oauthScreen.tapLoginButton()

        imageListScreen.waitForShowing(for: 20)
        XCTAssertTrue(imageListScreen.isShowing())
    }
    
    func testFeed() throws {
        openImageList()
        imageListScreen.waitForShowing()
        imageListScreen.swipeUp()
        imageListScreen.swipeDown()

        let isLikedAtStart = imageListScreen.isImageLiked()
        imageListScreen.tapLikeButton()
        CommonWaiter.waitFor(condition: { imageListScreen.isImageLiked() != isLikedAtStart }, timeout: 5, fail: false)
        XCTAssertNotEqual(isLikedAtStart, imageListScreen.isImageLiked(), "like should be changed after tap")
        imageListScreen.tapLikeButton()
        CommonWaiter.waitFor(condition: { imageListScreen.isImageLiked() == isLikedAtStart }, timeout: 5, fail: false)
        XCTAssertEqual(isLikedAtStart, imageListScreen.isImageLiked(), "like should be changed back")

        imageListScreen.tapImage()
        imageScreen.waitForShowing()
        imageScreen.zoomIn()
        imageScreen.zoomOut()
        imageScreen.tapBackButton()
        imageListScreen.waitForShowing()
    }
    
    // тестируем сценарий профиля
    func testProfile() throws {
        openImageList()
        imageListScreen.waitForShowing()

        app.tabBars.buttons.element(boundBy: 1).tap()
        profileScreen.waitForShowing()
        XCTAssertFalse( profileScreen.getLabelText(.nameLabel).isEmpty )

        XCTAssertTrue(profileScreen.getLabelText(.loginLabel).contains("@"), "login should contain @")

        profileScreen.tapLogoutButton()
        app.alerts["Пока, Пока!"].scrollViews.otherElements.buttons["Да"].tap()
        startScreen.waitForShowing()
    }
}

extension ImageFeedUITests {
    func openStartScreen() {
        CommonWaiter.waitFor(condition: { startScreen.isShowing() || imageListScreen.isShowing() }, timeout: 5, fail: false)
        if startScreen.isShowing() {
            return
        }
        app.tabBars.buttons.element(boundBy: 1).tap()
        profileScreen.waitForShowing()
        profileScreen.tapLogoutButton()
        app.alerts["Пока, Пока!"].scrollViews.otherElements.buttons["Да"].tap()
        startScreen.waitForShowing()
    }

    func openImageList() {
        CommonWaiter.waitFor(condition: { startScreen.isShowing() || imageListScreen.isShowing() }, timeout: 5, fail: false)
        if imageListScreen.isShowing() {
            return
        }
        startScreen.tapLoginButton()

        oauthScreen.waitForShowing()
        oauthScreen.enterLogin(yourLogin)
        oauthScreen.closeKeyboard()
        oauthScreen.enterPassword(yourPass)
        oauthScreen.closeKeyboard()
        oauthScreen.tapLoginButton()

        imageListScreen.waitForShowing(for: 20)
    }
}
