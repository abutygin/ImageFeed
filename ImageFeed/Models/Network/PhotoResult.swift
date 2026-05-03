//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 25.04.2026.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let urls: UrlsResult
    var isLiked: Bool
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdAt = "created_at"
        case description
        case urls
        case isLiked = "liked_by_user"
    }
}

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
