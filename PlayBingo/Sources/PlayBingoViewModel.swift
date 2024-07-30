import Foundation
import ServicesContracts

struct BingoCard {
    let title: String
    var tiles: [Tile]
    
    struct Tile: Identifiable {
        let text: String
        var selected: Bool
        
        let id: String = UUID().uuidString
    }
}

public final class PlayBingoViewModel: ObservableObject {
    private let bingoProvider: BingoProviderProtocol
    private let bingoUrl: URL?

    public init(bingoUrl: URL?, bingoProvider: BingoProviderProtocol) {
        self.bingoUrl = bingoUrl
        self.bingoProvider = bingoProvider
    }
    
    @Published private(set) var error: Error? = nil
    @Published private(set) var loading: Bool = true
    @Published private(set) var bingoCard: BingoCard? = nil
    
    func loadBingo() {
        loading = true
        
        Task { @MainActor [weak self] in
            guard let self else {
                return
            }
            do {
                let bingoCardModel = try await self.bingoProvider.getBingo(url: self.bingoUrl)
                
                self.bingoCard =  BingoCard(
                    title: bingoCardModel.name,
                    tiles: bingoCardModel.tiles.map({ tile in
                        BingoCard.Tile(text: tile.description, selected: false)
                    })
                )
                self.loading = false
            } catch {
                self.error = error
                self.loading = false
            }
        }
    }
    
    func toggleSelected(index: Int, selected: Bool) {
        guard bingoCard != nil else {
            assertionFailure("There is no bingo to play!")
            return
        }
        bingoCard?.tiles[index].selected.toggle()
    }
}
