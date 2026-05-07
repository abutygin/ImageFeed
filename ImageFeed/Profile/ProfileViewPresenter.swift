//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 05.05.2026.
//

import Foundation
import UIKit

public protocol ProfilePresenterProtocol {
    func onViewDidLoad()
    func onExitButtonTouched(vc: UIViewController)
    var view: ProfileViewControllerProtocol? { get set }
}

final class ProfileViewPresenter: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?

    private var profileImageServiceObserver: NSObjectProtocol?
    private var profileImageService = ProfileImageService.shared

    func onViewDidLoad() {
        if let profile = ProfileService.shared.profile {
            view?.updateProfileDetails(profile: profile)
        }
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }

    func onExitButtonTouched(vc: UIViewController) {
        let alert = UIAlertController(title: "Пока, Пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
        alert.addAction(UIAlertAction(title: "Да", style: .default) { _ in
            self.performLogout()
        })
        vc.present(alert, animated: true)
    }

    private func updateAvatar() {
        guard let avatarUrl = profileImageService.avatarURL else {
            return
        }
        view?.updateAvatar(avatarURL: avatarUrl)
    }

    private func performLogout() {
        ProfileLogoutService.shared.logoutAndClean()
        switchToSplashViewController()
    }

    private func switchToSplashViewController() {
        let window = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
        guard let window else {
            assertionFailure("Invalid window configuration")
            return
        }
        window.rootViewController = SplashViewController()
    }
}
