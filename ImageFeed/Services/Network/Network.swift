//
//  Network.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 19.04.2026.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case decodingError(Error)
}

enum HTTPMethod {
    static let get = "GET"
    static let post = "POST"
    static let put = "PUT"
}
