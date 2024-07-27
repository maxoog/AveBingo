//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 21.07.2024.
//

import Foundation

public struct Tile: Codable {
    public let description: String
    
    public init(description: String) {
        self.description = description
    }
}
