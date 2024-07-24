//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 12.07.2024.
//

import Foundation
import SwiftUI
import SharedUI
import Resources

public struct PlayBingoView: View {
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @ObservedObject var viewModel: PlayBingoViewModel
    
    @State private var screenshotMaker: ScreenshotMaker?
    
    public init(viewModel: PlayBingoViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Group {
            if let bingoCard = viewModel.bingoCard {
                bingoCardView(card: bingoCard)
                    .screenshotView { screenshotMaker in
                        self.screenshotMaker = screenshotMaker
                    }
            } else if viewModel.loading {
                ProgressView().onAppear(perform: viewModel.loadBingo)
            } else if let error = viewModel.error {
                ErrorView(error)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if viewModel.bingoCard != nil, 
                       let screenshotMaker,
                       let image = screenshotMaker.screenshot()
                    {
                        self.copyImageToClipboard(image: image)
                    }
                } label: {
                    Image("copy_icon", bundle: .assets)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.black)
                        .scaledToFill()
                        .frame(width: 34, height: 34)
                        .clipShape(Rectangle())
                }
            }
        }
    }
    
    private func bingoCardView(card bingoCard: BingoCard) -> some View {
        VStack(alignment: .center) {
            Text(bingoCard.title)
            
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
    }
}

private struct BingoCardView: View {
    @State private var width: CGFloat = 0
    
    let text: String
    @Binding var selected: Bool

    var body: some View {
        ZStack {
            (selected ? Color.green : Color.clear)
                .clipShape(Rectangle())
                .border(Color.black)
                .frame(height: width)
            
            Text(text)
                .padding(.horizontal, 8)
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
        Text("Some error occured \(error)")
    }
}

extension View {
    func copyImageToClipboard(image: UIImage) {
        let pasteboard = UIPasteboard.general
        pasteboard.image = image
        
        // To check if the image was successfully set in the clipboard.
        if pasteboard.image != nil {
            // If the image is not nil, it means it was successfully copied to the clipboard.
            print("Image copied to clipboard!")
        } else {
            // If the image is nil, print a failure message.
            print("Failed to copy image to clipboard.")
        }
    }
}
