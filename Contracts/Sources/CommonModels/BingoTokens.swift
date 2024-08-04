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
    case _3x3 = "3x3"
    case _4x4 = "4x4"
    
    public var numberOfCells: Int {
        rowSize * rowSize
    }
    
    public var rowSize: Int {
        switch self {
        case ._3x3:
            3
        case ._4x4:
            4
        }
    }
}

