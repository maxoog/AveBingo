//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 24.07.2024.
//

import Foundation
import BingoServices

public final class BingoHistoryViewModel: ObservableObject {
    private let bingoService: BingoService

    public init(bingoService: BingoService) {
        self.bingoService = bingoService
    }
}
