//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

/*import UIKit
 
 class SceneDelegate: UIResponder, UIWindowSceneDelegate {
 
 var window: UIWindow?
 
 func scene(_ scene: UIScene,
 willConnectTo session: UISceneSession,
 options connectionOptions: UIScene.ConnectionOptions) {
 
 guard let windowScene = (scene as? UIWindowScene) else { return }
 
 let window = UIWindow(windowScene: windowScene)
 
 if AppData.shared.isFirstAppStart {
 AppData.shared.isFirstAppStart = false
 
 let onboardingViewController = OnboardingViewController(
 transitionStyle: .scroll,
 navigationOrientation: .horizontal,
 options: nil
 )
 
 window.rootViewController = onboardingViewController
 } else {
 window.rootViewController = startViewController()
 }
 
 self.window = window
 window.makeKeyAndVisible()
 }
 
 /// Возвращает стартовый контроллер приложения
 func startViewController() -> UIViewController {
 return createTabBarController()
 }
 
 private func createTabBarController() -> UITabBarController {
 let tabBarController = UITabBarController()
 
 let trackersVC = TrackersViewController()
 trackersVC.tabBarItem = UITabBarItem(
 title: "Трекеры",
 image: UIImage(named: "record.circle.fill"),
 selectedImage: nil
 )
 
 let statisticsVC = StatisticsViewController()
 statisticsVC.tabBarItem = UITabBarItem(
 title: "Статистика",
 image: UIImage(systemName: "hare.fill"),
 selectedImage: nil
 )
 
 tabBarController.viewControllers = [trackersVC, statisticsVC]
 return tabBarController
 }
 }
 */
