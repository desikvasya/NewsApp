//
//  SceneDelegate.swift
//  NewsApp
//
//  Created by Виталий Коростелев on 12.01.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        let newsViewController = NewsViewController()
        let favoritesViewController = FavoritesViewController()

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [newsViewController, favoritesViewController]

        newsViewController.tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 0)
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 1)

        let navigationController = UINavigationController(rootViewController: tabBarController)

        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}
