//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 21.07.2024.
//

import Foundation

public struct AddBingoRequest: Encodable {
    public let tiles: [Tile]
    
    public init(tiles: [Tile]) {
        self.tiles = tiles
    }
}
