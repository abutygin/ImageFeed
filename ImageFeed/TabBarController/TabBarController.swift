//
//  TabBarController.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 20.04.2026.
//

import UIKit

final class TabBarController: UITabBarController {

    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        if let imagesListViewController = imagesListViewController as? ImagesListViewController {
            let imageListPresenter = ImagesListPresenter(imagesListService: ImagesListService.shared)
            imagesListViewController.configure(imageListPresenter)
        }
        let profileViewController = ProfileViewController()
        let profileViewPresenter = ProfileViewPresenter()
        profileViewController.configure(profileViewPresenter)
        profileViewController.tabBarItem = UITabBarItem(
           title: "", // если подпись не нужна, оставьте пустую строку
           image: UIImage(named: "tab_profile_active"),
           selectedImage: nil
        )
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "ypBlack")
        tabBar.standardAppearance = appearance
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
