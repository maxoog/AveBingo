//
//  EditBingoView.swift
//
//  Created by Maksim Zenkov on 11.07.2024.
//

import Foundation
import SwiftUI
import SharedUI

public struct EditBingoView: View {
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: EditBingoViewModel
    
    @State var bingoTitle: String = ""
    @State var bingoCards: [String] = .init(repeating: "", count: 9)
    @State var bingoSize: BingoGridSize = ._3x3
    @State var bingoStyle: BingoCellStyle = .stroke
    
    @State private var currentlySelectedCell: Int = 0
    
    public init(viewModel: EditBingoViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                EmojiView()
                
                TitleTextField(text: $bingoTitle)
                    .padding(.top, 16)
                
                GridSizePickerView(sizeSelection: $bingoSize)
                    .padding(.top, 24)
                
                BingoGridView(
                    model: .defaultModel,
                    style: bingoStyle,
                    size: bingoSize,
                    selectable: false
                ) { (index, tile) in
                    BingoCardView(
                        currentlySelectedCell: $currentlySelectedCell,
                        textValue: Binding {
                            bingoCards[index]
                        } set: { text in
                            bingoCards[index] = text
                        },
                        index: index
                    )
                }
                .padding(.top, 16)
                
                AveButton(
                    iconName: nil,
                    text: "Save changes",
                    onTap: {
                        Task {
                            await viewModel.postBingo(title: bingoTitle, tiles: bingoCards)
                        }
                    }
                )
            }
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationButton(iconName: "chevron_left_icon") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("Create new card")
                    .font(AveFont.headline3)
                    .foregroundStyle(AveColor.content)
            }
        }
    }
}

struct BingoCardView: View {
    @State private var width: CGFloat = 0

    @Binding var currentlySelectedCell: Int
    @Binding var textValue: String
    var index: Int
    
    var body: some View {
        BingoCellTextField(
            text: $textValue,
            currentlySelectedCell: $currentlySelectedCell,
            isFirstResponder: responder,
            index: index
        )
    }
    
    private var responder: Bool {
        return index == currentlySelectedCell
    }
}
