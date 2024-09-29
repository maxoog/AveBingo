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
import ServicesContracts

public struct EditBingoView: View {
    let analyticsService: AnalyticsServiceProtocol
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel: EditBingoViewModel
    
    @State private var currentlySelectedCell: Int = 0
    @FocusState private var emojiFieldIsFocused: Bool

    public init(
        viewModel: EditBingoViewModel,
        analyticsService: AnalyticsServiceProtocol
    ) {
        _viewModel = .init(wrappedValue: viewModel)
        self.analyticsService = analyticsService
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                if UITextInputMode.emojiTextInputMode != nil {
                    EmojiFieldView(text: $viewModel.model.emoji)
                        .frame(width: 100, height: 100)
                        .padding(.top, 16)
                        .focused($emojiFieldIsFocused)
                        .onTapGesture {
                            emojiFieldIsFocused = true
                        }
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
            VStack(spacing: 16) {
                PopupErrorView(visible: $viewModel.savingError)
                    .padding(.horizontal, 16)
                
                AveButton(
                    iconName: nil,
                    text: viewModel.isEditMode ? "Save changes" : "Create card",
                    isLoading: viewModel.isLoading,
                    enabled: viewModel.hasChanges,
                    onTap: {
                        Task {
                            UIApplication.shared.endEditing()
                            await viewModel.saveBingo()
                        }
                    }
                )
                .padding(.vertical, 16)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationButton(iconName: "chevron_left_icon") {
                    analyticsService.logEvent(EditEvent.backButton)
                    dismiss()
                }
                .padding(.bottom, 2)
            }
            
            ToolbarItem(placement: .principal) {
                Text("Edit card")
                    .font(AveFont.headline3)
                    .foregroundStyle(AveColor.content)
                    .lineLimit(1)
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
                    if self.height != height {
                        self.height = height
                    }
                }
            )
            .frame(height: height)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 4)
            .padding(.vertical, 1)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTapPublisher.send(())
        }
    }
    
    private var horizontalPadding: CGFloat {
        switch gridSize {
        case .small:
            8
        case .medium:
            4
        }
    }
}

extension UIApplication {
    fileprivate func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
