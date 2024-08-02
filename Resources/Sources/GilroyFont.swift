import SwiftUI

fileprivate struct FontName {
    private let name: String
    
    init(_ name: String) {
        self.name = name
    }
    
    func size(_ size: CGFloat) -> Font {
        return Font.custom(name, size: size)
    }
}

public enum GilroyFont: String, CaseIterable {
    case gilroyRegular = "Gilroy-Regular"
    case gilroyLight = "Gilroy-Light" // weight == 300
    case gilroyMedium = "Gilroy-Medium" // weight == 500
    case gilroySemiBold = "Gilroy-Semibold" // weight == 600
    case gilroyBold = "Gilroy-Bold"
    case gilroyBlack = "Gilroy-Black" // weight == 900
    
    public static func registerFonts() {
        Self.allCases.forEach { font in
            Self.registerFont(bundle: .module, fontName: font.rawValue, fontExtension: "ttf")
        }
    }
    
    private static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider)
        else {
            assertionFailure("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
            return
        }

        var error: Unmanaged<CFError>?

        CTFontManagerRegisterGraphicsFont(font, &error)
        if error != nil {
            assertionFailure(
                "Couldn't create font from filename: \(fontName) with extension \(fontExtension) with error: \(error.debugDescription)"
            )
        }
    }
}

public enum GilroyFontFactory {
    private static var registered: Bool = false
    
    public static func uiFont(
        size: CGFloat,
        weight: GilroyFont,
        fallback: UIFont
    ) -> UIFont {
        if !registered {
            GilroyFont.registerFonts()
            registered = true
        }
        
        let font: UIFont? = UIFont(name: weight.rawValue, size: size)
        guard let font else {
            assertionFailure("Error while creating font")
            return fallback
        }

        let fontDescriptor = font.fontDescriptor.addingAttributes([
            .featureSettings: [
                [
                    kCTFontFeatureTypeIdentifierKey: kTypographicExtrasType,
                    kCTFontFeatureSelectorIdentifierKey: kSlashedZeroOnSelector
                ]
            ]
        ])

        return UIFont(descriptor: fontDescriptor, size: size)
    }

    public static func font(
        size: CGFloat,
        weight: GilroyFont
    ) -> Font {
        let font = uiFont(size: size, weight: weight, fallback: .systemFont(ofSize: size))

        return Font(font)
    }
}


