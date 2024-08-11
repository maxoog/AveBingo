//
//  SceneDelegate.swift
//  AveBingoAppClip
//
//  Created by Maksim Zenkov on 12.07.2024.
//

import UIKit
import SwiftUI
import Foundation
import NetworkCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private let urlParser = URLParser()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else {
            return
        }

        let activityUrl = connectionOptions.userActivities.first?.webpageURL

        let window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController(
            rootViewController: UIHostingController(
                rootView: ScreenFactory.shared.playBingoView(bingoUrl: activityUrl)
            )
        )
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let activityUrl = userActivity.webpageURL,
           urlParser.isBingoURL(activityUrl)
        {
            window?.rootViewController = UIHostingController(
                rootView: ScreenFactory.shared.playBingoView(bingoUrl: activityUrl)
            )
        }
    }
}
