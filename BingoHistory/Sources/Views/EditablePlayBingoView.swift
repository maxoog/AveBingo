//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 08.08.2024.
//

import Foundation
import SwiftUI
import ScreenFactoryContracts
import CommonModels

public struct EditablePlayBingoView: View {
    let screenFactory: ScreenFactoryProtocol
    let playBingoOpenType: PlayBingoOpenType
    
    @State var bingoToEdit: BingoModel? = nil
    
    public init(
        screenFactory: ScreenFactoryProtocol,
        openType: PlayBingoOpenType
    ) {
        self.screenFactory = screenFactory
        self.playBingoOpenType = openType
    }
    
    public var body: some View {
        Group {
            if let bingoToEdit {
                screenFactory.editBingoView(openType: .edit(bingoToEdit))
            } else {
                screenFactory.playBingoView(
                    openType: playBingoOpenType,
                    onEdit: { bingo in
                        bingoToEdit = bingo
                    }
                )
            }
        }.animation(.easeOut, value: bingoToEdit)
    }
}
