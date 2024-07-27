//
//  EditBingoViewModel.swift
//
//  Created by Maksim Zenkov on 11.07.2024.
//

import Foundation
import BingoServices
import BingoServiceContracts

public final class EditBingoViewModel: ObservableObject {
    private let bingoService: BingoService
    
    @Published var error: Error?
    @Published var bingoID: String? = nil
    
    public init(bingoService: BingoService) {
        self.bingoService = bingoService
    }

    @MainActor
    func postBingo(title: String, tiles: [String]) async {
        let bingoModel = BingoModel(
            name: title,
            tiles: tiles.map { .init(description: $0) }
        )
        
        do {
            self.bingoID = try await bingoService.postBingo(bingo: bingoModel)
        } catch {
            self.error = error
            print(error)
        }
    }
}

