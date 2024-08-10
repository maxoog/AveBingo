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
    
    @State var screenType: ScreenType
    
    public init(
        screenFactory: ScreenFactoryProtocol,
        screenType: ScreenType
    ) {
        self.screenFactory = screenFactory
        self.screenType = screenType
    }
    
    public var body: some View {
//        Group {
            switch screenType {
            case .playBingo(let playBingoOpenType):
                screenFactory.playBingoView(
                    openType: playBingoOpenType,
                    onEdit: { bingo in
                        screenType = .editBingo(.edit(bingo))
                    }
                )
            case .editBingo(let editBingoOpenType):
                screenFactory.editBingoView(
                    openType: editBingoOpenType,
                    onSave: { bingo in
                        screenType = .playBingo(.card(bingo))
                    }
                )
            }
//        }.animation(.easeOut, value: screenType)
    }
}
