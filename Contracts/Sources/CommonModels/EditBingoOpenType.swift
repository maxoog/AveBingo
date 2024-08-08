//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 02.08.2024.
//

import Foundation

public enum EditBingoOpenType: Hashable {
    case createNew
    case edit(BingoModel)
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .createNew:
            hasher.combine("createNew")
        case .edit(let bingoModel):
            hasher.combine(bingoModel)
        }
    }
}
