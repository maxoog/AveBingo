//
//  AppDelegate.swift
//  AveBingoAppClip
//
//  Created by Maksim Zenkov on 12.07.2024.
//

import UIKit
import Mixpanel

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        setupApplication()
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
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
