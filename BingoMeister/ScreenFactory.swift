//
//  ScreenFactory.swift
//
//  Created by Maksim Zenkov on 11.07.2024.
//

import Foundation
import SwiftUI
import EditBingo
import NetworkClient
import BingoServices
import BingoHistory
import PlayBingo
import ScreenFactoryContracts
import Analytics

@MainActor
final class ScreenFactory: ScreenFactoryProtocol {
    static let shared = ScreenFactory()
    fileprivate let appFactory = AppFactory()
    
    func editBingoView() -> AnyView {
        AnyView(
            EditBingoView(viewModel: appFactory.editBingoViewModel())
        )
    }
    
    func bingoHistoryView() -> AnyView {
        AnyView(
            BingoHistoryView(
                screenFactory: self,
                viewModel: appFactory.bingoHistoryViewModel(),
                analyticsService: appFactory.analyticsService
            )
        )
    }
    
    func playBingoView() -> AnyView {
        AnyView(
            PlayBingoView(viewModel: appFactory.playBingoViewModel(bingoUrl: nil)) // TODO
        )
    }
}

@MainActor
fileprivate final class AppFactory {
    private lazy var networkClient = NetworkClient()
    
    private lazy var bingoService = BingoService(client: networkClient)
    
    lazy var analyticsService = AnalyticsService()
    
    func editBingoViewModel() -> EditBingoViewModel {
        EditBingoViewModel(bingoService: bingoService)
    }
    
    func bingoHistoryViewModel() -> BingoHistoryViewModel {
        BingoHistoryViewModel(bingoService: bingoService)
    }
    
    func playBingoViewModel(bingoUrl url: URL?) -> PlayBingoViewModel {
        PlayBingoViewModel(bingoUrl: url, bingoProvider: bingoService)
    }
}
