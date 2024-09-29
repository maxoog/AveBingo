//
//  File.swift
//
//
//  Created by Maksim Zenkov on 31.07.2024.
//

import Foundation
import SwiftUI

public enum BingoCellStyle: String, CaseIterable {
    case basic
    case stroke
    case retro
}

public enum BingoGridSize: String, CaseIterable {
    case small = "3x3"
    case medium = "4x4"

    public init?(numberOfTiles: Int) {
        if numberOfTiles == 9 {
            self = .small
            return
        } else if numberOfTiles == 16 {
            self = .medium
            return
        }

        return nil
    }

    public var numberOfCells: Int {
        rowSize * rowSize
    }

    public var rowSize: Int {
        switch self {
        case .small:
            3
        case .medium:
            4
        }
    }
}
