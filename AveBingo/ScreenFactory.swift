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

    func editBingoView(openType: EditBingoOpenType, onSave: @escaping (BingoModel) -> Void) -> AnyView {
        EditBingoView(
            viewModel: appFactory.editBingoViewModel(
                openType: openType,
                onSave: onSave
            ),
            analyticsService: appFactory.analyticsService
        ).anyView()
    }

    func bingoHistoryView(bingoURLToOpen: URL?) -> AnyView {
        NavigationView {
            BingoHistoryView(
                viewModel: appFactory.bingoHistoryViewModel(bingoURLToOpen: bingoURLToOpen),
                analyticsService: appFactory.analyticsService,
                screenFactory: self
            )
        }.anyView()
    }

    func playBingoView(openType: PlayBingoOpenType, onEdit: ((BingoModel) -> Void)?) -> AnyView {
        PlayBingoView(
            viewModel: appFactory.playBingoViewModel(openType: openType),
            analyticsService: appFactory.analyticsService,
            onEdit: onEdit
        ).anyView()
    }
}

@MainActor
private final class AppFactory {
    private lazy var networkClient = NetworkClient()

    private lazy var bingoService = BingoService(client: networkClient)

    lazy var analyticsService = AnalyticsService()

    func editBingoViewModel(
        openType: EditBingoOpenType,
        onSave: @escaping (BingoModel) -> Void
    ) -> EditBingoViewModel {
        EditBingoViewModel(
            openType: openType,
            bingoService: bingoService,
            analyticsService: analyticsService,
            onSave: onSave
        )
    }

    func bingoHistoryViewModel(bingoURLToOpen: URL?) -> BingoHistoryViewModel {
        BingoHistoryViewModel(bingoService: bingoService, bingoURLToOpen: bingoURLToOpen)
    }

    func playBingoViewModel(openType type: PlayBingoOpenType) -> PlayBingoViewModel {
        PlayBingoViewModel(openType: type, bingoProvider: bingoService)
    }
}
