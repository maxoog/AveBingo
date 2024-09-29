//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 21.07.2024.
//

import Foundation

public struct BingoResponse: Decodable {
    public let id: String
    public let title: String
    public let style: String
    public let emoji: String
    public let tiles: [Tile]

    public init(
        id: String,
        title: String,
        style: String,
        emoji: String,
        tiles: [Tile]
    ) {
        self.id = id
        self.title = title
        self.style = style
        self.emoji = emoji
        self.tiles = tiles
    }
}
