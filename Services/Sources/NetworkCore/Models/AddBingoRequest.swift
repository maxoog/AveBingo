//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 21.07.2024.
//

import Foundation

public struct AddBingoRequest: Encodable {
    public let title: String
    public let style: String
    public let emoji: String
    public let tiles: [Tile]

    public init(
        title: String,
        style: String,
        emoji: String,
        tiles: [Tile]
    ) {
        self.title = title
        self.style = style
        self.emoji = emoji
        self.tiles = tiles
    }
}
