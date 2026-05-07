//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by ALEXANDER BUTYGIN on 07.05.2026.
//

import ImageFeed
import Foundation
import UIKit

class ProfileViewPresenterSpy: ProfilePresenterProtocol {
    var didLoadCalled = false
    var exitCalled = false
    var view: ProfileViewControllerProtocol? = nil

    func onViewDidLoad() {
        didLoadCalled = true
    }

    func onExitButtonTouched(vc: UIViewController) {
        exitCalled = true
    }
}
