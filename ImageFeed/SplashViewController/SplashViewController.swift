//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 12.04.2026.
//

import UIKit

final class SplashViewController: UIViewController {
    private weak var logoImageView: UIImageView?
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let storage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = UIColor(named: "ypBlack")
        createLogo()
        layoutViews()
        if let token = storage.token {
            fetchProfile(token: token)
        } else {
            startAuthProcess()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        L.logger.info("SplashViewController.viewWillAppear() \(self)")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        L.logger.info("SplashViewController.viewWillDisappear() \(self)")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private func createLogo() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        guard let logo = UIImage(named: "splash_screen_logo") else {
            return
        }
        imageView.image = logo
        view.addSubview(imageView)
        logoImageView = imageView
    }

    private func layoutViews() {
        guard let logoImageView else {
            return
        }
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
}

extension SplashViewController {
    private func switchToTabBarController() {
        let window = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
        guard let window else {
            assertionFailure("Invalid window configuration")
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }

    private func startAuthProcess() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            assertionFailure("Не удалось найти AuthViewController по идентификатору")
            return
        }
        authController.delegate = self
        authController.modalPresentationStyle = .fullScreen
        let navigationController = UINavigationController(rootViewController: authController)
        navigationController.modalPresentationStyle = .fullScreen

        present(navigationController, animated: true)
    }

    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) {  result in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in }
                self.switchToTabBarController()
            case let .failure(error):
                L.logger.error("Error '\(error)' fetching profile")
                self.showErrorAlert("Error '\(error)' fetching profile")
                break
            }
        }
    }

}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        guard let token = storage.token else {
            switchToTabBarController()
            return
        }
        fetchProfile(token: token)
    }
}

extension SplashViewController {
    func showErrorAlert(_ text: String) {
        let alertController = UIAlertController(
            title: "Что-то пошло не так",
            message: text,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ок", style: .default) {_ in
            self.startAuthProcess()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

