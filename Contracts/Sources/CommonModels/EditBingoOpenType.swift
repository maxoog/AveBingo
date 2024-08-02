//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 02.08.2024.
//

import Foundation

public enum EditBingoOpenType: Identifiable {
    case createNew
    case edit(BingoModel)
    
    public var id: String {
        switch self {
        case .createNew:
            "CREATE_NEW"
        case .edit(let bingoModel):
            bingoModel.id
        }
    }
}
