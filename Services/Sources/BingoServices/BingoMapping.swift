//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 24.07.2024.
//

import Foundation
import ServicesContracts
import NetworkCore
import CommonModels

extension BingoResponse {
    func toBingoCardModel() -> BingoModel {
        BingoModel(
            name: "some random name",
            tiles: tiles.map {
                .init(description: $0.description)
            }
        )
    }
}
