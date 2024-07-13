//
//  ScreenFactory.swift
//  AvitoTest
//
//  Created by Maksim Zenkov on 11.07.2024.
//

import Foundation
import SwiftUI
import PlayBingo
import Network

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
    
    private lazy var networkClient = NetworkClient()
    
    private lazy var bingoFetchService = PlayBingoFetchService(client: networkClient)
    
    func playBingoViewModel(bingoUrl url: URL?) -> PlayBingoViewModel {
        PlayBingoViewModel(bingoUrl: url, fetchService: bingoFetchService)
    }
}

