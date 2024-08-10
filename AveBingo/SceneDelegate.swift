//
//  SceneDelegate.swift
//
//  Created by Maksim Zenkov on 10.07.2024.
//

import UIKit
import SwiftUI
import NetworkCore

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private let urlParser = URLParser()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else {
            return
        }
        
        let window = UIWindow(windowScene: scene)
        
        var bingoURLToOpen: URL?
        if let activityUrl = connectionOptions.userActivities.first?.webpageURL,
           urlParser.isBingoURL(activityUrl)
        {
            bingoURLToOpen = activityUrl
        }
        
        window.rootViewController = UIHostingController(
            rootView: ScreenFactory.shared.bingoHistoryView(bingoURLToOpen: bingoURLToOpen)
        )
        
        window.makeKeyAndVisible()
        self.window = window
    }

}


extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
