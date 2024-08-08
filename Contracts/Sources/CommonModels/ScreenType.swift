//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 02.08.2024.
//

import Foundation

public enum ScreenType: Hashable {
    case playBingo(PlayBingoOpenType)
    case editBingo(EditBingoOpenType)
}
