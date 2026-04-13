//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 12.04.2026.
//

import Foundation

final class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard

    var token: String? {
        get {
            userDefaults.string(forKey: Keys.token.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}

extension OAuth2TokenStorage {
    private enum Keys: String {
        case token
    }
}

