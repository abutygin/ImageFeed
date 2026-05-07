//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by ALEXANDER BUTYGIN on 05.05.2026.
//

import ImageFeed
import Foundation

class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var didLoadCalled = false

    var presenter: WebViewPresenterProtocol? = nil

    func load(request: URLRequest) {
        didLoadCalled = true
    }

    func setProgressValue(_ newValue: Float) {}

    func setProgressHidden(_ isHidden: Bool) {}
}
