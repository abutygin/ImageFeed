//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 18.04.2026.
//

import Foundation

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}

struct UserResult: Codable {
    let profileImage: ProfileImage
}

final class ProfileImageService {
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private lazy var jsonDecoder = SnakeCaseJSONDecoder()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?

    private init() {}

    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        task?.cancel()
        guard let token = OAuth2TokenStorage.shared.token else {
            completion(.failure(NSError(domain: "ProfileImageService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authorization token missing"])))
            return
        }
        guard let request = makeProfileImageRequest(username: username, token: token) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let task = URLSession.shared.objectTask(for: request, decoder: jsonDecoder) {  (result: Result<UserResult, Error>) in
            switch result {
            case .success(let result):
                self.avatarURL = result.profileImage.small
                completion(.success(result.profileImage.small))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": self.avatarURL ?? ""]
                    )
            case .failure(let error):
                L.logger.error("[fetchProfileImageURL]: Ошибка запроса: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }

    private func makeProfileImageRequest(username: String, token: String) -> URLRequest? {
        guard let url = URL(string: Constants.defaultBaseURLString + "/users/\(username)") else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
