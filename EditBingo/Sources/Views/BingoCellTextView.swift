import SwiftUI
import UIKit
import SharedUI
import Combine

struct BingoCellTextView: UIViewRepresentable {
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        let onPreferredHeightUpdated: ((CGFloat) -> Void)
        var didBecomeFirstResponder = false
        let placeholder: UILabel?
        
        var onTapPublisherCancellable: AnyCancellable? = nil

        init(
            text: Binding<String>,
            onPreferredHeightUpdated: @escaping ((CGFloat) -> Void),
            placeholder: UILabel?
        ) {
            _text = text
            self.onPreferredHeightUpdated = onPreferredHeightUpdated
            self.placeholder = placeholder
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            textView.resignFirstResponder()
            placeholder?.isHidden = !textView.text.isEmpty
        }
        
        func textViewDidChange(_ textView: UITextView) {
            onPreferredHeightUpdated(textView.sizeThatFits(textView.frame.size).height)
            placeholder?.isHidden = !textView.text.isEmpty
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            placeholder?.isHidden = true
        }

        func textViewDidChangeSelection(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.text = textView.text ?? ""
            }
        }
    }

    @Binding var text: String
    let onPreferredHeightUpdated: (CGFloat) -> Void
    let onTapPublisher: AnyPublisher<Void, Never>
    let placeholderLabel: UILabel = UILabel()
    
    init(
        text: Binding<String>,
        onTapPublisher: AnyPublisher<Void, Never>,
        onPreferredHeightUpdated: @escaping (CGFloat) -> Void
    ) {
        _text = text
        self.onTapPublisher = onTapPublisher
        self.onPreferredHeightUpdated = onPreferredHeightUpdated
    }

    func makeUIView(context: UIViewRepresentableContext<BingoCellTextView>) -> UITextView {
        let textView = UITextView(frame: .zero)
        
        placeholderLabel.text = "Type text\nhere"
        placeholderLabel.numberOfLines = 2
        placeholderLabel.textAlignment = .center
        placeholderLabel.font = AveFont.content2_uifont
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !textView.text.isEmpty
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: textView.centerXAnchor)
        ])
        
        textView.delegate = context.coordinator
        textView.textAlignment = .center
        textView.keyboardType = .default
        textView.font = AveFont.content2_uifont
        textView.tintColor = UIColor(AveColor.content)
        textView.textContainer.maximumNumberOfLines = 5
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.textAlignment = .center
        textView.textContainer.lineBreakMode = .byTruncatingTail
        
        context.coordinator.onTapPublisherCancellable = onTapPublisher.sink { _ in
            textView.becomeFirstResponder()
        }
        
        return textView
    }

    func makeCoordinator() -> BingoCellTextView.Coordinator {
        return Coordinator(
            text: $text,
            onPreferredHeightUpdated: onPreferredHeightUpdated,
            placeholder: placeholderLabel
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

