import Foundation
import SwiftUI

extension View {
    public func widthChanged(_ widthCallback: @escaping (CGFloat) -> Void) -> some View {
        modifier(widthUpdater(widthCallback: widthCallback))
    }
}

private struct widthUpdater: ViewModifier {
    let widthCallback: (CGFloat) -> Void

    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { proxy in
                    Color.clear.preference(key: widthPreference.self, value: proxy.size.width)
                }
                .onPreferenceChange(widthPreference.self, perform: widthCallback)
            }
    }
}

private struct widthPreference: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
