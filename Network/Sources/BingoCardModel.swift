import Foundation

public struct BingoCardModel: Codable {
    public struct Tile: Codable {
        public let description: String
    }
    
    public let id: String
    public let name: String
    public let tiles: [Tile]
    
    public static var defaultModel: BingoCardModel {
        BingoCardModel(id: "", name: "Успешный пет проект бинго", tiles: [
            .init(description: "Подключиться к гиту куда же без него"),
            .init(description: ""),
            .init(description: "написать 3 строки кода"),
            
            .init(description: ""),
            .init(description: ""),
            .init(description: ""),
            
            .init(description: ""),
            .init(description: ""),
            .init(description: "забить на проект через 2 дня"),
        ])
    }
}
