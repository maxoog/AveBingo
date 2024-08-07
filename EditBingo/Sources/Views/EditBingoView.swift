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
    
    @ObservedObject var viewModel: EditBingoViewModel
    
    @State private var currentlySelectedCell: Int = 0
    
    public init(viewModel: EditBingoViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                EmojiView()
                
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
                        textValue: $viewModel.model.tiles[index]
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
        }
        .overlay(alignment: .bottom) {
            AveButton(
                iconName: nil,
                text: viewModel.isEditMode ? "Save changes" : "Create card",
                onTap: {
                    Task {
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
