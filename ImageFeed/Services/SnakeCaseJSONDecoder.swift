//
//  SnakeCaseJSONDecoder.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 17.04.2026.
//

import Foundation

class SnakeCaseJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
