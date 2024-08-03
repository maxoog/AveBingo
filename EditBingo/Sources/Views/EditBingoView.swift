//
//  EditBingoView.swift
//
//  Created by Maksim Zenkov on 11.07.2024.
//

import Foundation
import SwiftUI
import SharedUI
import Combine

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
                    selectable: false,
                    passTouchesToContent: true
                ) { (index, tile) in
                    BingoCardView(
                        textValue: Binding {
                            bingoCards[index]
                        } set: { text in
                            bingoCards[index] = text
                        }
                    )
                }
                .padding(.top, 16)
            }
            .padding(.horizontal, 16)
        }
        .overlay(alignment: .bottom) {
            AveButton(
                iconName: nil,
                text: "Save changes",
                onTap: {
                    Task {
                        await viewModel.postBingo(title: bingoTitle, tiles: bingoCards)
                    }
                }
            )
            .padding(.vertical, 16)
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
    @State private var height: CGFloat = 40
    @State private var firstResponder: Bool = false
    @State var onTapPublisher = PassthroughSubject<Void, Never>()

    @Binding var textValue: String
    
    var body: some View {
        ZStack {
            Color.clear
            
            BingoCellTextView(
                text: $textValue,
                onTapPublisher: onTapPublisher.eraseToAnyPublisher(),
                onPreferredHeightUpdated: { height in
                    self.height = height
                }
            )
            .frame(height: height)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 8)
            .padding(.vertical, 1)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTapPublisher.send(())
        }
    }
}
