//
//  AveBingoAppClipApp.swift
//  AveBingoAppClip
//
//  Created by Maksim Zenkov on 10.08.2024.
//

import SwiftUI

@main
struct AveBingoAppClipApp: App {
    @State private var activityURL: URL? = nil
    
    var body: some Scene {
        WindowGroup {
//            Text("хуй")
            ScreenFactory.shared.playBingoView(bingoUrl: activityURL)
                .onContinueUserActivity("NSUserActivityTypeBrowsingWeb", perform: { userActivity in
                    activityURL = userActivity.webpageURL
                })
        }
    }
}

