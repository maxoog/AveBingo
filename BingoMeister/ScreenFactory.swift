//
//  ScreenFactory.swift
//  AvitoTest
//
//  Created by Maksim Zenkov on 11.07.2024.
//

import Foundation
import SwiftUI
import EditBingo
import NetworkCore
import BingoServices

let screenFactory = ScreenFactory()

final class ScreenFactory {
    static let shared = ScreenFactory()
    
    func editBingoView() -> some View {
        EditBingoView(viewModel: AppFactory.shared.editBingoViewModel())
    }
}

final class AppFactory {
    static let shared = AppFactory()
    
    private lazy var networkClient = NetworkClient()
    
    private lazy var bingoService = BingoService(client: networkClient)
    
    func editBingoViewModel() -> EditBingoViewModel {
        EditBingoViewModel(bingoService: bingoService)
    }
}
