//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 31.07.2024.
//

import Foundation
import SwiftUI
import CommonModels

 extension BingoCellStyle {
    public var previewImageName: String {
        switch self {
        case .basic:
            "basic_style"
        case .stroke:
            "stroke_style"
        case .retro:
            "retro_style"
        }
    }
    
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

extension BingoGridSize {
    static let colors3x3: [Color] = [
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
    
    static let colors4x4: [Color] = [
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

extension BingoGridSize {
    public var textFont: Font {
        switch self {
        case ._3x3:
            AveFont.content2
        case ._4x4:
            AveFont.content3
        }
    }
    
    public var textUIFont: UIFont {
        switch self {
        case ._3x3:
            AveFont.content2_uifont
        case ._4x4:
            AveFont.content3_uifont
        }
    }
    
    public var maxNumberOfLinesInTextField: Int {
        switch self {
        case ._3x3:
            5
        case ._4x4:
            4
        }
    }
}
