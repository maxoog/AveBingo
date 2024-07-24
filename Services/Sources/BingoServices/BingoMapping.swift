//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 24.07.2024.
//

import Foundation

extension BingoResponse {
    func toBingoCardModel() -> BingoCardModel {
        BingoCardModel(
            name: "some random name",
            tiles: tiles.map {
                .init(description: $0.description)
            }
        )
    }
}
