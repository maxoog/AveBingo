import Foundation

public enum PlayBingoOpenType: Hashable {
    case card(BingoModel)
    case deeplink(URL?)

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .card(let bingoModel):
            hasher.combine(bingoModel)
        case .deeplink(let url):
            hasher.combine(url)
        }
    }
}
