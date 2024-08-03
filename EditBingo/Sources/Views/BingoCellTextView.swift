import SwiftUI
import UIKit
import SharedUI

struct BingoCellTextView: UIViewRepresentable {
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        
        let onPreferredHeightUpdated: ((CGFloat) -> Void)
        
        let index: Int

        var didBecomeFirstResponder = false

        init(
            text: Binding<String>,
            index: Int,
            onPreferredHeightUpdated: @escaping ((CGFloat) -> Void)
        ) {
            _text = text
            self.index = index
            self.onPreferredHeightUpdated = onPreferredHeightUpdated
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            textView.resignFirstResponder()
        }
        
        func textViewDidChange(_ textView: UITextView) {
            onPreferredHeightUpdated(textView.sizeThatFits(textView.frame.size).height)
        }

        func textViewDidChangeSelection(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.text = textView.text ?? ""
            }
        }
    }

    @Binding var text: String
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
            index: index,
            onPreferredHeightUpdated: onPreferredHeightUpdated
        )
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<BingoCellTextView>) {
        uiView.text = text
        
        if !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}

