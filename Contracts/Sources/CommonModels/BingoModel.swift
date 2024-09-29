import Foundation

public struct BingoModel: Identifiable, Equatable, Hashable {
    public struct Tile: Equatable, Hashable {
        public let description: String

        public init(description: String) {
            self.description = description
        }
    }
    public let id: String
    public let name: String
    public let style: BingoCellStyle
    public let size: BingoGridSize
    public let emoji: String
    public let tiles: [Tile]

    public init(
        id: String,
        name: String,
        style: BingoCellStyle,
        size: BingoGridSize,
        emoji: String,
        tiles: [Tile]
    ) {
        self.id = id
        self.name = name
        self.style = style
        self.size = size
        self.emoji = emoji
        self.tiles = tiles
    }

    public static var defaultModel: BingoModel {
        BingoModel(
            id: "some_id",
            name: "Скуф бинго",
            style: .basic,
            size: .small,
            emoji: "p",
            tiles: [
                .init(description: "Лысеешь"),
                .init(description: "Пьёшь пиво хотя бы раз в неделю + у тебя есть питомец"),
                .init(description: "Мамкин политик"),

                .init(description: "Одеваешься во что попало"),
                .init(description: "30+"),
                .init(description: "Компьютерные игры как смысл жизни"),

                .init(description: "Ешь какое-то хрючево"),
                .init(description: "Работаешь на заводе и тп"),
                .init(description: "Любишь рыбалку")
            ]
        )
    }
}
