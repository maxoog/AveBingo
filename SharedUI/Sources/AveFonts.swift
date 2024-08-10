import Resources
import SwiftUI

public enum AveFont {
    public static let headline1: Font = GilroyFontFactory.font(
        size: 26,
        weight: .gilroyBlack
    )
    public static let headline2: Font = GilroyFontFactory.font(
        size: 24,
        weight: .gilroyMedium
    )
    public static let headline3: Font = GilroyFontFactory.font(
        size: 18,
        weight: .gilroySemiBold
    )
    public static let content: Font = GilroyFontFactory.font(
        size: 20,
        weight: .gilroyMedium
    )
    public static let content2: Font = GilroyFontFactory.font(
        size: 16,
        weight: .gilroyMedium
    )
    public static let content2_uifont: UIFont = GilroyFontFactory.uiFont(
        size: 16,
        weight: .gilroyMedium
    )
    public static let content3: Font = GilroyFontFactory.font(
        size: 14,
        weight: .gilroyMedium
    )
    public static let content3_uifont: UIFont = GilroyFontFactory.uiFont(
        size: 14,
        weight: .gilroyMedium
    )
}
