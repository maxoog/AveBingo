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
    
    @ObservedObject var viewModel: EditBingoViewModel
    
    @State var bingoTitle: String = ""
    @State var bingoCards: [String] = .init(repeating: "", count: 9)
    
    @State private var currentlySelectedCell: Int = 0
    
    public init(viewModel: EditBingoViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            TextField(text: $bingoTitle, prompt: Text("Title").font(.title), label: {})
                .font(.title)
                .multilineTextAlignment(.center)
                .tint(.black)
                .frame(minWidth: 200, alignment: .center)
                .padding(.horizontal, 16)
            
            LazyVGrid(
                columns: columns,
                spacing: 5
            ) {
                ForEach(Array(bingoCards.enumerated()), id: \.offset) { (index, card) in
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
            }
            
            
            Button(action: {
                Task {
                    await viewModel.postBingo(title: bingoTitle, tiles: bingoCards)
                }
            }, label: {
                Text("Save bingo")
                    .foregroundStyle(Color.white)
                    .background {
                        Color.secondary.frame(width: 200, height: 56)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
            })
            .padding(.top, 24)
        }
    }
}

struct BingoCardView: View {
    @State private var width: CGFloat = 0

    @Binding var currentlySelectedCell: Int
    @Binding var textValue: String
    var index: Int
    
    var body: some View {
        ZStack {
            Color.gray
                .clipShape(Rectangle())
                .frame(height: width)
            
            CustomTextField(
                text: $textValue,
                currentlySelectedCell: $currentlySelectedCell,
                isFirstResponder: responder,
                index: index
            )
            .tint(.black)
        }
        .frame(maxWidth: .infinity)
        .widthChanged { newWidth in
            width = newWidth
        }
    }
    
    private var responder: Bool {
        return index == currentlySelectedCell
    }
}

