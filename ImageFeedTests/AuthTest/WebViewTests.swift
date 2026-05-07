//
//  WebViewTests.swift
//  WebViewTests
//
//  Created by ALEXANDER BUTYGIN on 05.05.2026.
//

@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        // when
        _ = viewController.view

        // then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }

    func testPresenterCallsLoadRequest() {
        // given
        let helperDouble = AuthHelperDouble()
        let presenter = WebViewPresenter(authHelper: helperDouble)
        let webViewViewControllerSpy = WebViewViewControllerSpy()
        presenter.view = webViewViewControllerSpy

        // when
        presenter.viewDidLoad()
        // then
        XCTAssertTrue(webViewViewControllerSpy.didLoadCalled) //behaviour verification
    }

    func testProgressVisibleWhenLessThenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6

        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)

        //then
        XCTAssertFalse(shouldHideProgress)
    }

    func testProgressIsHiddenWhenEqualsOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0

        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)

        //then
        XCTAssertTrue(shouldHideProgress)
    }

    func testAuthHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)

        //when
        let url = authHelper.authURL()

        guard let urlString = url?.absoluteString else {
            XCTFail("Auth URL is nil")
            return
        }

        //then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }

    func testCodeFromURL() {
        // given
        let authHelper = AuthHelper()
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native") else {
            XCTFail("error creating URLComponents")
            return
        }
        let expectedCode = "test code"
        urlComponents.queryItems = [
            URLQueryItem(name: "code", value: expectedCode),
        ]
        guard let url = urlComponents.url else {
            XCTFail("error creating url from components")
            return
        }
        
        // when
        let actualCode = authHelper.code(from: url)

        // then
        XCTAssertEqual(expectedCode, actualCode, "check code from url")
    }
}
