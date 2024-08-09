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
import CommonModels

@MainActor
final class ScreenFactory: ScreenFactoryProtocol {
    fileprivate let appFactory = AppFactory()
    
    static let shared = ScreenFactory()
    
    func editBingoView(openType: EditBingoOpenType) -> AnyView {
        EditBingoView(
            viewModel: appFactory.editBingoViewModel(openType: openType)
        ).anyView()
    }
    
    func bingoHistoryView() -> AnyView {
        NavigationView {
            BingoHistoryView(
                viewModel: appFactory.bingoHistoryViewModel(),
                analyticsService: appFactory.analyticsService,
                screenFactory: self
            )
        }.anyView()
    }
    
    func playBingoView(openType: PlayBingoOpenType, onEdit: ((BingoModel) -> Void)?) -> AnyView {
        PlayBingoView(
            viewModel: appFactory.playBingoViewModel(openType: openType),
            onEdit: onEdit
        ).anyView()
    }
}

@MainActor
fileprivate final class AppFactory {
    private lazy var networkClient = NetworkClient()
    
    private lazy var bingoService = BingoService(client: networkClient)
    
    lazy var analyticsService = AnalyticsService()
    
    func editBingoViewModel(openType: EditBingoOpenType) -> EditBingoViewModel {
        EditBingoViewModel(openType: openType, bingoService: bingoService)
    }
    
    func bingoHistoryViewModel() -> BingoHistoryViewModel {
        BingoHistoryViewModel(bingoService: bingoService)
    }
    
    func playBingoViewModel(openType type: PlayBingoOpenType) -> PlayBingoViewModel {
        PlayBingoViewModel(openType: type, bingoProvider: bingoService)
    }
}
