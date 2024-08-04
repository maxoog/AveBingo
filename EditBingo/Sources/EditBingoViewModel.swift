//
//  EditBingoViewModel.swift
//
//  Created by Maksim Zenkov on 11.07.2024.
//

import Foundation
import BingoServices
import ServicesContracts
import CommonModels

struct EditableBingoModel {
    var title: String
    var tiles: [String]
    var size: BingoGridSize
    var style: BingoCellStyle
    
    static var initDefault: EditableBingoModel {
        let size = BingoGridSize._3x3
        
        return EditableBingoModel(
            title: "",
            tiles: .init(repeating: "", count: size.numberOfCells),
            size: size,
            style: .basic
        )
    }
    
    init(
        title: String,
        tiles: [String],
        size: BingoGridSize,
        style: BingoCellStyle
    ) {
        self.title = title
        self.tiles = tiles
        self.size = size
        self.style = style
    }
    
    init(from model: BingoModel) {
        self.title = model.name
        self.tiles = model.tiles.map { $0.description }
        self.size = model.size
        self.style = model.style
    }
    
    func toBingoModel() -> BingoModel {
        BingoModel(
            name: title,
            style: style,
            size: size,
            tiles: tiles.map { .init(description: $0) }
        )
    }
}

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

