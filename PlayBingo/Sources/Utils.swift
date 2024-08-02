//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 31.07.2024.
//

import Foundation
import CommonModels

extension PlayBingoViewModel {
    static func makeBingoURL(bingo: BingoModel) -> URL? {
        return URL(string: "https://avebingo.com/bingo/" + bingo.id)
    }
}
