//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 24.07.2024.
//

import Foundation
import CommonModels

public protocol BingoProviderProtocol {
    func getBingo(url: URL?) async throws -> BingoModel
}
