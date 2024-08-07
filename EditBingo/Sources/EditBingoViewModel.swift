//
//  EditBingoViewModel.swift
//
//  Created by Maksim Zenkov on 11.07.2024.
//

import Foundation
import BingoServices
import ServicesContracts
import CommonModels

@MainActor
public final class EditBingoViewModel: ObservableObject {
    private let bingoService: BingoService
    
    @Published var error: Error?
    @Published var model: EditableBingoModel
    @Published var bingoValidationError: Bool = false
    
    var isEditMode: Bool {
        bingoID != nil
    }
    
    @Published private var bingoID: String? = nil
    
    public init(openType: EditBingoOpenType, bingoService: BingoService) {
        self.bingoService = bingoService
        
        switch openType {
        case .createNew:
            self.model = .initDefault
        case .edit(let bingoModel):
            self.model = .init(from: bingoModel)
            self.bingoID = bingoModel.id
        }
    }

    func saveBingo() async {
        guard !model.title.isEmpty else {
            bingoValidationError = true
            return
        }
        
        do {
            if let bingoID {
                let bingoModel = model.toBingoModel(id: bingoID)
                try await bingoService.editBingo(bingoModel)
            } else {
                self.bingoID = try await bingoService.createBingo(
                    name: model.title,
                    style: model.style,
                    emoji: model.emoji,
                    tiles: model.tiles.map { .init(description: $0) }
                )
            }
        } catch {
            self.error = error
            print(error)
        }
    }
}



