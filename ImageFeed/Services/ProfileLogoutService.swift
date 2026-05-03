//
//  LogoutProfileService.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 22.04.2026.
//

import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()

    private init() {}

    func logoutAndClean() {
        OAuth2TokenStorage.shared.token = nil
        ProfileService.shared.logoutProfile()
        ImagesListService.shared.logoutImagesList()
        ProfileImageService.shared.logoutProfileImage()
        cleanCookies()
    }

    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        let dataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: dataTypes) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
