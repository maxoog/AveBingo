//
//  EditBingoViewModel.swift
//
//  Created by Maksim Zenkov on 11.07.2024.
//

import Foundation
import BingoServices
import ServicesContracts
import CommonModels

public final class EditBingoViewModel: ObservableObject {
    private let bingoService: BingoService
    
    @Published var error: Error?
    @Published var bingoID: String? = nil
    
    @Published var model: EditableBingoModel
    
    @Published var bingoValidationError: Bool = false
    
    public init(openType: EditBingoOpenType, bingoService: BingoService) {
        self.bingoService = bingoService
        
        switch openType {
        case .createNew:
            self.model = .initDefault
        case .edit(let bingoModel):
            self.model = .init(from: bingoModel)
        }
    }

    @MainActor
    func postBingo() async {
        guard !model.title.isEmpty else {
            bingoValidationError = true
            return
        }
        
        let bingoModel = model.toBingoModel()
        
        do {
            self.bingoID = try await bingoService.postBingo(bingo: bingoModel)
        } catch {
            self.error = error
            print(error)
        }
    }
}

