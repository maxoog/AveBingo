//
//  AppDelegate.swift
//
//  Created by Maksim Zenkov on 10.07.2024.
//

import UIKit
import Mixpanel
import Analytics

final class AppDelegate: UIResponder, UIApplicationDelegate {

    override init() {
        StartupMetricsProvider.shared.track(.`init`)

        super.init()
    }

    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        setupApplication()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    private func setupApplication() {
        // Initializing Mixpanel
        #if DEBUG
            Mixpanel.initialize(
                token: "XXX",
                trackAutomaticEvents: false
            )
        #else
            Mixpanel.initialize(
                token: "XXX",
                trackAutomaticEvents: false
            )
        #endif
    }
}
