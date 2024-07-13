//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 12.07.2024.
//

import Foundation
import SwiftUI
import SharedUI

public struct PlayBingoView: View {
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @ObservedObject var viewModel: PlayBingoViewModel
    
    public init(viewModel: PlayBingoViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        if let bingoCard = viewModel.bingoCard {
            VStack(alignment: .center) {
                Text("Bingo-Huingo")
                
                LazyVGrid(
                    columns: columns,
                    spacing: 5
                ) {
                    ForEach(Array(bingoCard.tiles.enumerated()), id: \.1.id) { (index, tile) in
                        BingoCardView(
                            text: tile.text,
                            selected: Binding {
                                bingoCard.tiles[index].selected
                            } set: { selected in
                                viewModel.toggleSelected(index: index, selected: selected)
                            }
                        )
                    }
                }
            }
        } else if viewModel.loading {
            ProgressView().onAppear(perform: viewModel.loadBingo)
        } else if let error = viewModel.error {
            ErrorView(error)
        }
    }
}

private struct BingoCardView: View {
    @State private var width: CGFloat = 0
    
    let text: String
    @Binding var selected: Bool
    
    var body: some View {
        ZStack {
            (selected ? Color.green : Color.gray)
                .clipShape(Rectangle())
                .frame(height: width)
            
            Text(text)
        }
        .widthChanged { newWidth in
            width = newWidth
        }
        .contentShape(Rectangle())
        .onTapGesture {
            selected.toggle()
        }
    }
}

private struct ErrorView: View {
    let error: Error
    
    init(_ error: Error) {
        self.error = error
    }
    
    var body: some View {
        Text("Some error occured \(error.localizedDescription)")
    }
}
