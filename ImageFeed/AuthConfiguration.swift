//
//  Constants.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 06.04.2026.
//

import Foundation

enum Constants {
    static let accessKey = "GJViv5kLHkdkTvdpEzG1FRdeUf47Hz7WnunT1FPgVb4"
    static let secretKey = "7ssBisfAlg9-p1tCxZaSWmNDYX4YgYzJaV04m8nBnbU"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURLString = "https://api.unsplash.com"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURLString: String
    let authURLString: String

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURLString = defaultBaseURLString
        self.authURLString = authURLString
    }

    static var standard: AuthConfiguration {
        AuthConfiguration(accessKey: Constants.accessKey,
                          secretKey: Constants.secretKey,
                          redirectURI: Constants.redirectURI,
                          accessScope: Constants.accessScope,
                          authURLString: Constants.unsplashAuthorizeURLString,
                          defaultBaseURLString: Constants.defaultBaseURLString)
    }
}
