import Foundation

public struct BingoCardModel: Codable {
    public struct Tile: Codable {
        public let description: String
    }
    
    public let id: String
    public let name: String
    public let tiles: [Tile]
    
    public static var defaultModel: BingoCardModel {
        BingoCardModel(id: "", name: "Bingo huingo", tiles: [
            .init(description: "Hello"),
            .init(description: "Maan"),
            .init(description: "i am a "),
            
            .init(description: "gooool"),
            .init(description: "gooooal"),
            .init(description: "huiase"),
            
            .init(description: ""),
            .init(description: ""),
            .init(description: "lol kek"),
        ])
    }
}
