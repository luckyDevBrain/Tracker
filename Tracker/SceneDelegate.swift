//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Class Definition

/// Делегат сцены для настройки окна и интерфейса приложения
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties
    
    var window: UIWindow?
    
    // MARK: - Scene Lifecycle
    
    /// Настраивает окно и корневой контроллер при подключении новой сцены
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        setupWindow(with: windowScene)
        configureTabBarController()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
    
    // MARK: - Private Methods
    
    private func setupWindow(with windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
    }
    
    private func configureTabBarController() {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.barStyle = .default
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.backgroundColor = .ypWhiteDay
        tabBarController.tabBar.layer.borderColor = UIColor.ypGray.cgColor
        tabBarController.tabBar.layer.borderWidth = 1
        
        let habitsVC = HabitsViewController()
        let habitsIcon = UIImage(named: "record.circle.fill") ?? UIImage()
        habitsVC.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: habitsIcon,
            selectedImage: nil
        )
        
        let statsVC = HabitStatisticsViewController()
        let statsIcon = UIImage(systemName: "hare.fill") ?? UIImage()
        statsVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: statsIcon,
            selectedImage: nil
        )
        
        tabBarController.setViewControllers([habitsVC, statsVC], animated: true)
        window?.rootViewController = tabBarController
    }
}
