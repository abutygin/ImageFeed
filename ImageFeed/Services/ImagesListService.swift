//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 23.04.2026.
//

import Foundation


final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")

    private(set) var photos: [Photo] = []
    private var isLoading = false
    private var lastLoadedPage: Int?
    private let isoFormatter = ISO8601DateFormatter()
    private lazy var jsonDecoder = JSONDecoder()

    private init() {}

    func fetchPhotosNextPage() {
        guard !isLoading else { return }
        isLoading = true
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let token = OAuth2TokenStorage.shared.token,
        let request = makeImagesRequest(page: nextPage, token: token) else {
            isLoading = false
            return
        }

        let task = URLSession.shared.objectTask(for: request, decoder: jsonDecoder) { (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let photoResults):
                let isoFormatter = self.isoFormatter
                let newPhotos = photoResults.map { result in
                    let date = result.createdAt.flatMap {
                        isoFormatter.date(from: $0)
                    }
                    return Photo(
                        id: result.id,
                        size: CGSize(width: result.width, height: result.height),
                        createdAt: date,
                        welcomeDescription: result.description,
                        thumbImageURL: result.urls.thumb,
                        largeImageURL: result.urls.full,
                        isLiked: result.isLiked
                    )
                }
                self.photos.append(contentsOf: newPhotos)
                self.lastLoadedPage = nextPage
                self.isLoading = false

                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)

            case .failure(let error):
                DispatchQueue.main.async {
                    L.logger.error("ImageListService: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }
        }
        task.resume()
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = OAuth2TokenStorage.shared.token else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        guard let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like") else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? HTTPMethod.post : HTTPMethod.delete
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func updatePhotoLike(photoId: String) {
        if let index = photos.firstIndex(where: { $0.id == photoId }) {
            let photo = photos[index]

            let newPhoto = photo.toggleLike()
            photos[index] = newPhoto
        }
    }

    func logoutImagesList() {
        photos = []
        isLoading = false
        lastLoadedPage = nil
    }

    private func makeImagesRequest(page: Int, token: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.defaultBaseURLString + "/photos") else {
            assertionFailure("Failed to create URL for ImagesRequest")
            return nil
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: "10"),
        ]

        guard let photosUrl = urlComponents.url else {
            return nil
        }
        var request = URLRequest(url: photosUrl)
        request.httpMethod = HTTPMethod.get
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
