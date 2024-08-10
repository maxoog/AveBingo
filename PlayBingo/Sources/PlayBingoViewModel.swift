import Foundation
import ServicesContracts
import CommonModels

enum PlayBingoViewState {
    case loading
    case error(Error)
    case content(BingoModel)
    
    var canLoadBingo: Bool {
        switch self {
        case .loading, .error:
            return true
        case .content:
            return false
        }
    }
    
    var bingo: BingoModel? {
        switch self {
        case .loading, .error:
            nil
        case .content(let bingoModel):
            bingoModel
        }
    }
}

public final class PlayBingoViewModel: ObservableObject {
    private let bingoProvider: BingoProviderProtocol
    var bingoURL: URL?
    let isMyBingo: Bool

    public init(openType: PlayBingoOpenType, bingoProvider: BingoProviderProtocol) {
        self.bingoProvider = bingoProvider
        
        switch openType {
        case .card(let bingoModel):
            isMyBingo = true
            bingoURL = Self.makeBingoURL(bingo: bingoModel)
            state = .content(bingoModel)
        case .deeplink(let url):
            isMyBingo = false
            bingoURL = url
            state = .loading
        }
    }
    
    @Published private(set) var state: PlayBingoViewState
    
    func loadBingo() {
        guard let bingoURL = self.bingoURL, state.canLoadBingo else {
            return
        }
        
        state = .loading
        
        Task { @MainActor [weak self] in
            guard let self else {
                return
            }
            do {
                let bingoModel = try await self.bingoProvider.getBingo(url: bingoURL)
                
                self.state = .content(bingoModel)
            } catch {
                self.state = .error(error)
            }
        }
    }
}
