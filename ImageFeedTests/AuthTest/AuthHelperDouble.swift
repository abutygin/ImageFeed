//
//  AuthHelperDouble.swift
//  ImageFeedTests
//
//  Created by ALEXANDER BUTYGIN on 05.05.2026.
//

import ImageFeed
import Foundation

class AuthHelperDouble: AuthHelperProtocol {
    func authRequest() -> URLRequest? {
        guard let url = URL(string: "https://some.site") else {
            return nil
        }
        let request = URLRequest(url: url)
        return request
    }

    func code(from url: URL) -> String? {
        return ""
    }
}
