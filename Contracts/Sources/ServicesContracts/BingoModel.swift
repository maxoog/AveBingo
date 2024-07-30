import Foundation

public struct BingoModel {
    public struct Tile {
        public let description: String
        
        public init(description: String) {
            self.description = description
        }
    }
    
    public let id = UUID().uuidString
    public let name: String
    public let tiles: [Tile]
    
    public init(name: String, tiles: [Tile]) {
        self.name = name
        self.tiles = tiles
    }
    
    public static var defaultModel: BingoModel {
        BingoModel(name: "Успешный пет проект бинго", tiles: [
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

