//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 31.07.2024.
//

import Foundation
import SwiftUI
import CommonModels

public typealias CellModel = (Int, BingoModel.Tile)

public struct BingoGridView<Content: View>: View {
    let model: BingoModel
    let style: BingoCellStyle
    let size: BingoGridSize
    let selectable: Bool
    let cellContent: (CellModel) -> Content
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    public init(
        model: BingoModel,
        style: BingoCellStyle,
        size: BingoGridSize,
        selectable: Bool,
        cellContent: @escaping (CellModel) -> Content
    ) {
        self.model = model
        self.cellContent = cellContent
        self.style = style
        self.size = size
        self.selectable = selectable
    }
    
    public var body: some View {
        LazyVGrid(
            columns: columns,
            spacing: 8
        ) {
            ForEach(Array(model.tiles.enumerated()), id: \.0) { cellModel in
                BingoCellView(
                    style: style,
                    size: size,
                    index: cellModel.offset,
                    selectable: selectable
                ) {
                    cellContent(cellModel)
                }
            }
        }
    }
}

private struct BingoCellView<Content: View>: View {
    let style: BingoCellStyle
    let size: BingoGridSize
    let index: Int
    let selectable: Bool
    let content: () -> Content
    
    @State private var width: CGFloat = 0
    @State var selected: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(style.backgroundColor(index: index, size: size))
                .frame(height: width)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(style.strokeColor)
                }
            
            content()
        }
        .widthChanged { newWidth in
            width = newWidth
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if selectable {
                selected.toggle()
            }
        }
        .overlay(alignment: .topLeading) {
            if selected {
                Image(style.checkIconName, bundle: .assets)
                    .padding(8)
            }
        }
        .animation(.interactiveSpring(duration: 0.1), value: selected)
    }
}
