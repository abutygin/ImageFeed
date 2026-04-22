//
//  LogoutProfileService.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 22.04.2026.
//

import WebKit

final class LogoutProfileService {
    static let shared = LogoutProfileService()

    private init() {}

    func logoutAndClean() {
        OAuth2TokenStorage.shared.token = nil
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        let dataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let dateFrom = Date.distantPast
        WKWebsiteDataStore.default().removeData(ofTypes: dataTypes, modifiedSince: dateFrom) {
            // Done clearing cache
        }
    }
}
