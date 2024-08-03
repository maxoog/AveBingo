import SwiftUI
import UIKit
import SharedUI

struct BingoCellTextView: UIViewRepresentable {
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        @Binding var currentlySelectedCell: Int
        
        let onPreferredHeightUpdated: ((CGFloat) -> Void)
        
        let index: Int

        var didBecomeFirstResponder = false

        init(
            text: Binding<String>,
            currentlySelectedCell: Binding<Int>,
            index: Int,
            onPreferredHeightUpdated: @escaping ((CGFloat) -> Void)
        ) {
            _text = text
            _currentlySelectedCell = currentlySelectedCell
            self.index = index
            self.onPreferredHeightUpdated = onPreferredHeightUpdated
        }
        
        
        func textViewDidEndEditing(_ textView: UITextView) {
            textView.resignFirstResponder()
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            currentlySelectedCell = index
        }
        
        func textViewDidChange(_ textView: UITextView) {
            onPreferredHeightUpdated(textView.sizeThatFits(textView.frame.size).height)
        }

        func textViewDidChangeSelection(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.text = textView.text ?? ""
            }
        }
        
        func textViewShouldReturn(_ textView: UITextView) -> Bool {
            self.currentlySelectedCell += 1
            return false
        }
    }

    @Binding var text: String
    @Binding var currentlySelectedCell: Int
    var isFirstResponder: Bool = false
    let index: Int
    let onPreferredHeightUpdated: (CGFloat) -> Void

    func makeUIView(context: UIViewRepresentableContext<BingoCellTextView>) -> UITextView {
        let textView = UITextView(frame: .zero)
        textView.delegate = context.coordinator
        textView.textAlignment = .center
        textView.keyboardType = .default
        textView.font = AveFont.content2_uifont
        textView.tintColor = UIColor(AveColor.content)
        textView.textContainer.maximumNumberOfLines = 5
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.textAlignment = .center
        textView.textContainer.lineBreakMode = .byTruncatingTail
        return textView
    }

    func makeCoordinator() -> BingoCellTextView.Coordinator {
        return Coordinator(
            text: $text,
            currentlySelectedCell: $currentlySelectedCell,
            index: index,
            onPreferredHeightUpdated: onPreferredHeightUpdated
        )
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<BingoCellTextView>) {
        uiView.text = text
        
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}

