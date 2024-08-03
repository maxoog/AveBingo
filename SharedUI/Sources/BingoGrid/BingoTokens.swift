//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 31.07.2024.
//

import Foundation
import SwiftUI

public enum BingoCellStyle {
    case basic
    case stroke
    case retro
    
    var strokeColor: Color {
        switch self {
        case .basic:
            Color.clear
        case .stroke, .retro:
            AveColor.content
        }
    }
    
    var checkIconName: String {
        switch self {
        case .basic, .stroke:
            "check_icon"
        case .retro:
            "check_icon_white"
        }
    }
    
    func backgroundColor(index: Int, size: BingoGridSize) -> Color {
        switch self {
        case .basic:
            AveColor.backgroundLight
        case .stroke:
            Color.clear
        case .retro:
            switch size {
            case ._3x3:
                BingoGridSize.colors3x3[index]
            case ._4x4:
                BingoGridSize.colors4x4[index]
            }
        }
    }
}

public enum BingoGridSize: String, CaseIterable {
    case _3x3 = "3x3"
    case _4x4 = "4x4"
    
    static let colors3x3 = [
        AveColor.lilac2,
        AveColor.orange,
        AveColor.pang,
        
        AveColor.orange,
        AveColor.green,
        AveColor.pink,
        
        AveColor.red2,
        AveColor.lilac2,
        AveColor.orange
    ]
    
    static let colors4x4 = [
        AveColor.lilac2,
        AveColor.orange,
        AveColor.green,
        AveColor.orange,
        
        AveColor.lilac2,
        AveColor.pink,
        AveColor.orange,
        AveColor.red2,
        
        AveColor.red2,
        AveColor.orange,
        AveColor.lilac2,
        AveColor.pang,
        
        AveColor.pink,
        AveColor.orange,
        AveColor.pink,
        AveColor.green
    ]
}
