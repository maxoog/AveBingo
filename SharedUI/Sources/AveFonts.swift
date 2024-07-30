import Resources
import SwiftUI

public enum AveFont {
    public static let headline1: Font = GilroyFontFactory.font(
        size: 26,
        weight: .gilroyBlack,
        fallback: .boldSystemFont(ofSize: 26)
    )
    public static let headline2: Font = GilroyFontFactory.font(
        size: 24,
        weight: .gilroyMedium,
        fallback: .boldSystemFont(ofSize: 24)
    )
    public static let content: Font = GilroyFontFactory.font(
        size: 20,
        weight: .gilroyMedium,
        fallback: .boldSystemFont(ofSize: 20)
    )
}
