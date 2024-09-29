//
//  BingoGridView.swift
//
//
//  Created by Maksim Zenkov on 31.07.2024.
//

import Foundation
import SwiftUI
import CommonModels

public struct BingoGridView<Content: View, Tile>: View {
    public typealias CellModel = (Int, Tile)

    let tiles: [Tile]
    let style: BingoCellStyle
    let size: BingoGridSize
    let selectable: Bool
    let passTouchesToContent: Bool
    let cellContent: (CellModel) -> Content

    private var columns: [GridItem] {
        .init(repeating: GridItem(.flexible()), count: size.rowSize)
    }

    public init(
        tiles: [Tile],
        style: BingoCellStyle,
        size: BingoGridSize,
        selectable: Bool,
        passTouchesToContent: Bool,
        cellContent: @escaping (CellModel) -> Content
    ) {
        self.tiles = tiles
        self.style = style
        self.size = size
        self.selectable = selectable
        self.passTouchesToContent = passTouchesToContent
        self.cellContent = cellContent
    }

    public var body: some View {
        LazyVGrid(
            columns: columns,
            spacing: 8
        ) {
            ForEach(Array(tiles.enumerated()), id: \.0) { cellModel in
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
