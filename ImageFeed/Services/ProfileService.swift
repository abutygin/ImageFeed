//
//  ProfileService.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 18.04.2026.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String
}

final class ProfileService {
    static let shared = ProfileService()
    private(set) var profile: Profile?
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private lazy var jsonDecoder = SnakeCaseJSONDecoder()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?

    private init() {}

    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        task?.cancel()
        guard let request = makeProfileRequest(token: token) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let task = URLSession.shared.objectTask(for: request, decoder: jsonDecoder) { (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let result):
                let profile = Profile(profileResult: result)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                L.logger.error("[fetchProfile]: Ошибка запроса: \(error.localizedDescription)")
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }

    private func makeProfileRequest(token: String) -> URLRequest? {
        let profileUrl = URL(string: Constants.defaultBaseURLString + "/me")
        guard let profileUrl else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: profileUrl)
        request.httpMethod = HTTPMethod.get
        request.setValue("v1", forHTTPHeaderField: "Accept-Version")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

extension Profile {
    init(profileResult: ProfileResult) {
        username = profileResult.username
        name = Profile.constructName(profileResult: profileResult)
        loginName = "@\(username)"
        bio = profileResult.bio ?? ""
    }

    private static func constructName(profileResult: ProfileResult) -> String {
        var name = profileResult.firstName
        if profileResult.lastName.isEmpty {
            return name
        }
        name += " \(profileResult.lastName)"
        return name
    }
}
