//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 03.04.2026.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private weak var avatarImageView: UIImageView?
    private weak var exitButton: UIButton?
    private weak var nameLabel: UILabel?
    private weak var loginLabel: UILabel?
    private weak var descriptionLabel: UILabel?
    private var profileImageServiceObserver: NSObjectProtocol?
    private var textAnimationLayers = Array<CALayer>()
    private var imageAnimationLayers = Array<CALayer>()
    private var animationLayers: Array<CALayer> {
        textAnimationLayers + imageAnimationLayers
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "ypBlack")
        createAvatar()
        createNameLabel(name: "Имя не указано")
        createLoginLabel(login: "@неизвестный_пользователь")
        createStatusLabel(status: "Профиль не заполнен")
        createExitButton()
        layoutViews()
        setupAnimations()

        if let profile = ProfileService.shared.profile {
            updateProfileDetails(profile: profile)
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateGradientFrames()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeTextGradients()
        removeImageGradients()
    }

    @objc private func exitButtonTouched() {
        L.logger.info("exitButtonTouched()")
        let alert = UIAlertController(title: "Пока, Пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
        alert.addAction(UIAlertAction(title: "Да", style: .default) { _ in
            self.performLogout()
        })
        present(alert, animated: true)
    }

    private func performLogout() {
        ProfileLogoutService.shared.logoutAndClean()
        switchToSplashViewController()
    }

    func updateProfileDetails(profile: Profile) {
        if !profile.name.isEmpty {
            nameLabel?.text = profile.name
        }
        if !profile.loginName.isEmpty {
            loginLabel?.text = profile.loginName
        }
        if !profile.bio.isEmpty {
            descriptionLabel?.text = profile.bio
        }
        removeTextGradients()
    }

    private func createAvatar() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        guard let avatar = UIImage(named: "avatar") else {
            return
        }
        imageView.image = avatar
        view.addSubview(imageView)
        avatarImageView = imageView
    }

    private func createNameLabel(name: String) {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = name
        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        label.textColor = .white
        nameLabel = label
        view.addSubview(label)
    }

    private func createLoginLabel(login: String) {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = login
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        let loginColor = UIColor(red: (174/255.0), green: (175/255.0), blue: (180/255.0), alpha: 1.0)
        label.textColor = loginColor
        loginLabel = label
        view.addSubview(label)
    }

    private func createStatusLabel(status: String) {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = status
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        descriptionLabel = label
        view.addSubview(label)
    }

    private func createExitButton() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        exitButton = button
        guard let exitImage = UIImage(named: "exit_button") else {
            return
        }
        button.setImage(exitImage, for: .normal)
        button.addTarget(self, action: #selector(exitButtonTouched), for: .touchUpInside)
    }

    private func layoutViews() {
        guard let avatarImageView,
              let nameLabel,
              let loginLabel,
              let descriptionLabel,
              let exitButton else {
            return
        }

        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor),
            exitButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let imageUrl = URL(string: profileImageURL)
        else { return }

        L.logger.info("imageUrl: \(imageUrl)")

        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))

        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        avatarImageView?.kf.indicatorType = .activity
        avatarImageView?.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "avatar"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh
            ]) { result in

                switch result {
                case .success(let value):
                    self.removeImageGradients()
                    L.logger.info("Картинка профиля: \(value.image)")
                    L.logger.info("Тип кэша: \(value.cacheType)")
                    L.logger.info("Информация об источнике: \(value.source)")
                case .failure(let error):
                    L.logger.error("Ошибка загрузки картинки профиля \(error)")
                }
            }
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

    private func makeAnimatedGradient(frame: CGRect, cornerRadius: CGFloat) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = frame

        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = cornerRadius
        gradient.masksToBounds = true

        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]

        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
        return gradient
    }

    private func addGradient(to view: UIView?, layers: inout Array<CALayer>) {
        guard let view else {
            L.logger.info("Profile addGradient view == nil")
            return
        }
        let gradient = makeAnimatedGradient(frame: view.bounds, cornerRadius: view.bounds.height / 2)
        view.layer.addSublayer(gradient)
        layers.append(gradient)
    }

    private func removeTextGradients() {
        textAnimationLayers.forEach {
            $0.removeFromSuperlayer()
        }
        textAnimationLayers.removeAll()
    }

    private func removeImageGradients() {
        imageAnimationLayers.forEach {
            $0.removeFromSuperlayer()
        }
        imageAnimationLayers.removeAll()
    }

    private func updateGradientFrames() {
        for layer in animationLayers {
            layer.frame = layer.superlayer?.bounds ?? .zero
            layer.cornerRadius = (layer.superlayer?.bounds.height ?? 0) / 2.0
        }
    }

    private func setupAnimations() {
        addGradient(to: avatarImageView, layers: &imageAnimationLayers)
        addGradient(to: nameLabel, layers: &textAnimationLayers)
        addGradient(to: loginLabel, layers: &textAnimationLayers)
        addGradient(to: descriptionLabel, layers: &textAnimationLayers)
    }
}
