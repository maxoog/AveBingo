//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 24.07.2024.
//

import Foundation
import SwiftUI
import ServicesContracts
import CommonModels

@MainActor
public protocol ScreenFactoryProtocol {
    func editBingoView(openType: EditBingoOpenType, onSave: @escaping (BingoModel) -> Void) -> AnyView
    func playBingoView(openType: PlayBingoOpenType, onEdit: ((BingoModel) -> Void)?) -> AnyView
}
