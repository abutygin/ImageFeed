//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 12.04.2026.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let userDefaults = UserDefaults.standard

    private init() {}

    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: Keys.tokenKey.rawValue)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: Keys.tokenKey.rawValue)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Keys.tokenKey.rawValue)
            }
        }
    }
}

extension OAuth2TokenStorage {
    private enum Keys: String {
        case tokenKey = "token"
    }
}

