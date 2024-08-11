//
//  AppDelegate.swift
//
//  Created by Maksim Zenkov on 10.07.2024.
//

import UIKit
import Mixpanel

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        setupApplication()
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    private func setupApplication() {
        // Initializing Mixpanel
        #if DEBUG
            Mixpanel.initialize(
                token: "383b3217aefa52e70b15fa52d92d56ed",
                trackAutomaticEvents: false
            )
        #else
            Mixpanel.initialize(
                token: "0aea82bb50aa9f21a0d9775d08983485",
                trackAutomaticEvents: false
            )
        #endif
    }
}


