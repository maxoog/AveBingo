//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 24.07.2024.
//

import Foundation
import SwiftUI

@MainActor
public protocol ScreenFactoryProtocol {
    func editBingoView() -> AnyView
    func playBingoView() -> AnyView
}
