//
//  ScreenFactory.swift
//
//  Created by Maksim Zenkov on 11.07.2024.
//

import Foundation
import SwiftUI
import PlayBingo
import BingoServicesForAppClip

@MainActor
final class ScreenFactory {
    static let shared = ScreenFactory()
    
    func playBingoView(bingoUrl url: URL?) -> some View {
        PlayBingoView(viewModel: AppFactory.shared.playBingoViewModel(bingoUrl: url))
    }
}

@MainActor
final class AppFactory {
    static let shared = AppFactory()
    
    private lazy var bingoService = BingoServiceForAppClip()
    
    func playBingoViewModel(bingoUrl url: URL?) -> PlayBingoViewModel {
        PlayBingoViewModel(bingoUrl: url, bingoProvider: bingoService)
    }
}
