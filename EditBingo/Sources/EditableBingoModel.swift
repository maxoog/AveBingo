import Foundation
import CommonModels

struct EditableBingoModel: Equatable {
    var title: String
    var tiles: [String]
    var size: BingoGridSize {
        willSet {
            adjustTiles(for: newValue)
        }
    }
    var emoji: String
    var style: BingoCellStyle

    static var initDefault: EditableBingoModel {
        let size = BingoGridSize.small

        return EditableBingoModel(
            title: "",
            tiles: .init(repeating: "", count: size.numberOfCells),
            size: size,
            style: .basic,
            emoji: ""
        )
    }

    init(
        title: String,
        tiles: [String],
        size: BingoGridSize,
        style: BingoCellStyle,
        emoji: String
    ) {
        self.title = title
        self.tiles = tiles
        self.size = size
        self.style = style
        self.emoji = emoji
    }

    init(from model: BingoModel) {
        self.title = model.name
        self.tiles = model.tiles.map { $0.description }
        self.size = model.size
        self.style = model.style
        self.emoji = model.emoji
    }

    func toBingoModel(id: String) -> BingoModel {
        BingoModel(
            id: id,
            name: title,
            style: style,
            size: size,
            emoji: emoji,
            tiles: tiles.map { .init(description: $0) }
        )
    }

    private mutating func adjustTiles(for newSize: BingoGridSize) {
        if tiles.count != newSize.numberOfCells {
            if newSize.numberOfCells > size.numberOfCells {
                let additionalTiles = newSize.numberOfCells - size.numberOfCells
                tiles.append(contentsOf: Array(repeating: "", count: additionalTiles))
            } else {
                tiles = Array(tiles.prefix(newSize.numberOfCells))
            }
        }
    }
}
