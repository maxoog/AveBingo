import Foundation
import SwiftUI

extension View {
    public func widthChanged(_ widthCallback: @escaping (CGFloat) -> Void) -> some View {
        modifier(WidthUpdater(widthCallback: widthCallback))
    }
}

private struct WidthUpdater: ViewModifier {
    let widthCallback: (CGFloat) -> Void

    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { proxy in
                    Color.clear.preference(key: WidthPreference.self, value: proxy.size.width)
                }
                .onPreferenceChange(WidthPreference.self, perform: widthCallback)
            }
    }
}

private struct WidthPreference: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
