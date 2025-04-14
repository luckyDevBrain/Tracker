//
//  AppDelegate.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit
import YandexMobileMetrica

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // Initializing the AppMetrica SDK.
        let configuration = YMMYandexMetricaConfiguration.init(apiKey: "42e0eec8-dee7-4761-994a-1926cbc97de3")
        YMMYandexMetrica.activate(with: configuration!)

        window = UIWindow()
        window?.makeKeyAndVisible()

        if AppData.shared.isFirstAppStart {
            AppData.shared.isFirstAppStart = false
            let onboardingViewController = OnboardingViewController(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal,
                options: nil
            )
            window?.rootViewController = onboardingViewController
        } else {
            window?.rootViewController = StartViewController()
        }
        return true
    }
}
