import Foundation

public struct BingoCardModel: Codable {
    public struct Tile: Codable {
        public let id: String
        public let description: String
    }
    
    public let id: String
    public let name: String
    public let tiles: [Tile]
}
