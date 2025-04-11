//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var onboardingViewController = OnboardingViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    )

    lazy var startViewController: UITabBarController = {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.barStyle = .default
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.backgroundColor = .ypWhiteDay
        tabBarController.tabBar.layer.borderColor = UIColor.ypGray.cgColor
        tabBarController.tabBar.layer.borderWidth = 1

        let trackersListViewController = TrackersViewController()
        trackersListViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "record.circle.fill"),
            selectedImage: nil
        )

        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(systemName: "hare.fill"),
            selectedImage: nil
        )

        tabBarController.setViewControllers([trackersListViewController, statisticsViewController], animated: false)
        return tabBarController
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        if AppData.isFirstAppStart {
            AppData.isFirstAppStart = false
            window.rootViewController = onboardingViewController
        } else {
            window.rootViewController = startViewController
        }

        self.window = window
        window.makeKeyAndVisible()
    }
}
