//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by ALEXANDER BUTYGIN on 06.05.2026.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {

    func testProfileViewControllerDidLoad() {
        // given
        let profileViewController = ProfileViewController()
        let profileViewPresenterSpy = ProfileViewPresenterSpy()
        profileViewController.configure(profileViewPresenterSpy)

        // when
        _ = profileViewController.view

        // then
        XCTAssertTrue(profileViewPresenterSpy.didLoadCalled)
    }

    func testProfileViewControllerExit() {
        // given
        let profileViewController = ProfileViewController()
        let profileViewPresenterSpy = ProfileViewPresenterSpy()
        profileViewController.configure(profileViewPresenterSpy)

        // when
        profileViewController.exitButtonTouched()

        // then
        XCTAssertTrue(profileViewPresenterSpy.exitCalled)
    }
}
