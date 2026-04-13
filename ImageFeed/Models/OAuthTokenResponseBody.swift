//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 12.04.2026.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let access_token: String
    let token_type: String
    let scope: String
    let created_at: Int
}
