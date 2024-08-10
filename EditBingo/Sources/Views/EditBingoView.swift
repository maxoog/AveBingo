//
//  EditBingoView.swift
//
//  Created by Maksim Zenkov on 11.07.2024.
//

import Foundation
import SwiftUI
import SharedUI
import Combine
import CommonModels

public struct EditBingoView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel: EditBingoViewModel
    
    @State private var currentlySelectedCell: Int = 0
    @FocusState private var emojiFieldIsFocused: Bool

    public init(viewModel: EditBingoViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                EmojiFieldView(text: $viewModel.model.emoji)
                    .frame(width: 100, height: 100)
                    .padding(.top, 16)
                    .focused($emojiFieldIsFocused)
                    .onTapGesture {
                        emojiFieldIsFocused = true
                    }
                
                TitleTextField(text: $viewModel.model.title, error: viewModel.bingoValidationError)
                    .padding(.top, 16)
                
                GridSizePickerView(sizeSelection: $viewModel.model.size)
                    .padding(.top, 24)
                
                BingoGridView(
                    tiles: viewModel.model.tiles,
                    style: viewModel.model.style,
                    size: viewModel.model.size,
                    selectable: false,
                    passTouchesToContent: true
                ) { (index, tile) in
                    BingoCardView(
                        textValue: $viewModel.model.tiles[index],
                        gridSize: viewModel.model.size
                    )
                }
                .padding(.top, 16)
                .animation(.default, value: viewModel.model.style)
                .animation(.default, value: viewModel.model.size)
                
                StylePickerView(sizeSelection: $viewModel.model.style)
                    .padding(.top, 24)
                    .padding(.bottom, 132)
            }
            .padding(.horizontal, 16)
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
        .overlay(alignment: .bottom) {
            AveButton(
                iconName: nil,
                text: viewModel.isEditMode ? "Save changes" : "Create card",
                isLoading: viewModel.isLoading,
                onTap: {
                    Task {
                        UIApplication.shared.endEditing()
                        await viewModel.saveBingo()
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
                .padding(.bottom, 2)
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
    let gridSize: BingoGridSize
    
    var body: some View {
        ZStack {
            Color.clear
            
            BingoCellTextView(
                text: $textValue,
                gridSize: gridSize,
                onTapPublisher: onTapPublisher.eraseToAnyPublisher(),
                onPreferredHeightUpdated: { height in
                    self.height = height
                }
            )
            .frame(height: height)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, 1)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTapPublisher.send(())
        }
    }
    
    private var horizontalPadding: CGFloat {
        switch gridSize {
        case ._3x3:
            8
        case ._4x4:
            6
        }
    }
}

extension UIApplication {
    fileprivate func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
