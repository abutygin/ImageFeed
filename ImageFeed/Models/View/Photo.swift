//
//  Photo.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 25.04.2026.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool

    func toggleLike() -> Photo {
        Photo(id: id, size: size, createdAt: createdAt, welcomeDescription: welcomeDescription, thumbImageURL: thumbImageURL, largeImageURL: largeImageURL, isLiked: !isLiked)
    }
}
