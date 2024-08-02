import Foundation

public enum PlayBingoOpenType {
    case card(BingoModel)
    case deeplink(URL?)
}
