//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 12.04.2026.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    let oAuth2TokenStorage = OAuth2TokenStorage()

    private lazy var jsonDecoder = JSONDecoder()

    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let urlRequest = makeOAuthTokenRequest(code: code) else {
            return
        }
        let task = URLSession.shared.data(for: urlRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let authTokenResponse = try self.jsonDecoder.decode(OAuthTokenResponseBody.self, from: data)
                    self.oAuth2TokenStorage.token = authTokenResponse.accessToken
                    completion(.success(authTokenResponse.accessToken))
                } catch {
                    let dataStr = String(data: data, encoding: .utf8) ?? ""
                    L.logger.error("Error '\(error)' decoding data: '\(dataStr)'")
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }

    private init() {}

    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            return nil
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]

        guard let authTokenUrl = urlComponents.url else {
            return nil
        }

        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = HTTPMethod.post
        return request
    }
}

enum HTTPMethod {
    static let get = "GET"
    static let post = "POST"
    static let put = "PUT"
}

