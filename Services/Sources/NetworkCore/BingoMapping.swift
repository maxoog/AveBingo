//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 24.07.2024.
//

import Foundation
import ServicesContracts
import CommonModels

public extension BingoResponse {
    func toBingoCardModel() -> BingoModel {
        BingoModel(
            name: title,
            style: BingoCellStyle(rawValue: style) ?? .basic,
            size: BingoGridSize(numberOfTiles: tiles.count) ?? ._3x3,
            emoji: emoji,
            tiles: tiles.map {
                .init(description: $0.description)
            }
        )
    }
}

public extension BingoModel {
    func toAddBingoRequest() -> AddBingoRequest {
        AddBingoRequest(
            title: name,
            style: style.rawValue,
            emoji: emoji,
            tiles: tiles.map { .init(description: $0.description) }
        )
    }
}
