//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 03.04.2026.
//

import UIKit

final class ProfileViewController: UIViewController {
    private weak var avatarImageView: UIImageView?
    private weak var exitButton: UIButton?
    private weak var nameLabel: UILabel?
    private weak var loginLabel: UILabel?
    private weak var statusLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        createAvatar()
        createNameLabel(name: "Екатерина Новикова")
        createLoginLabel(login: "@ekaterina_nov")
        createStatusLabel(status: "Hello, world!")
        createExitButton()
        layoutViews()
    }

    @objc func exitButtonTouched() {
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
        statusLabel = label
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
              let statusLabel,
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
            statusLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor),
            exitButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}
