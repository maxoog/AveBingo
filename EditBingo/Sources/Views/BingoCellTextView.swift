import SwiftUI
import UIKit
import SharedUI
import Combine
import CommonModels

struct BingoCellTextView: UIViewRepresentable {
    final class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        let onPreferredHeightUpdated: ((CGFloat) -> Void)
        var placeholder: UILabel? = nil
        
        var onTapPublisherCancellable: AnyCancellable? = nil

        init(
            text: Binding<String>,
            onPreferredHeightUpdated: @escaping ((CGFloat) -> Void)
        ) {
            _text = text
            self.onPreferredHeightUpdated = onPreferredHeightUpdated
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            placeholder?.isHidden = !textView.text.isEmpty
        }
        
        func textViewDidChange(_ textView: UITextView) {
            onPreferredHeightUpdated(textView.sizeThatFits(textView.frame.size).height)
            placeholder?.isHidden = !textView.text.isEmpty || textView.isFirstResponder
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            placeholder?.isHidden = true
        }

        func textViewDidChangeSelection(_ textView: UITextView) {
            placeholder?.isHidden = !textView.text.isEmpty || textView.isFirstResponder
            
            DispatchQueue.main.async {
                self.text = textView.text ?? ""
            }
        }
    }

    @Binding var text: String
    let gridSize: BingoGridSize
    let onPreferredHeightUpdated: (CGFloat) -> Void
    let onTapPublisher: AnyPublisher<Void, Never>
    
    @StaticState
    private var heightUpdated: Bool = false
    
    init(
        text: Binding<String>,
        gridSize: BingoGridSize,
        onTapPublisher: AnyPublisher<Void, Never>,
        onPreferredHeightUpdated: @escaping (CGFloat) -> Void
    ) {
        _text = text
        self.gridSize = gridSize
        self.onTapPublisher = onTapPublisher
        self.onPreferredHeightUpdated = onPreferredHeightUpdated
    }

    func makeUIView(context: UIViewRepresentableContext<BingoCellTextView>) -> UITextView {
        let textView = UITextView(frame: .zero)
        
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Type text\nhere"
        placeholderLabel.numberOfLines = 2
        placeholderLabel.textAlignment = .center
        placeholderLabel.font = gridSize.textFont
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !textView.text.isEmpty
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: textView.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: textView.centerYAnchor)
        ])
        
        textView.delegate = context.coordinator
        textView.textAlignment = .center
        textView.keyboardType = .default
        
        textView.font = gridSize.textFont
        textView.tintColor = UIColor(AveColor.content)
        textView.textContainer.maximumNumberOfLines = gridSize.maxNumberOfLinesInTextField
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        textView.textAlignment = .center
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.backgroundColor = .clear
        
        context.coordinator.onTapPublisherCancellable = onTapPublisher.sink { _ in
            textView.becomeFirstResponder()
        }
        context.coordinator.placeholder = placeholderLabel
        
        return textView
    }

    func makeCoordinator() -> BingoCellTextView.Coordinator {
        return Coordinator(
            text: $text,
            onPreferredHeightUpdated: onPreferredHeightUpdated
        )
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<BingoCellTextView>) {
        uiView.text = text
        updateForSize(
            textView: uiView,
            placeholder: context.coordinator.placeholder,
            size: gridSize
        )
        
        if !text.isEmpty && !heightUpdated {
            Task { @MainActor in
                onPreferredHeightUpdated(uiView.sizeThatFits(uiView.frame.size).height)
                heightUpdated = true
            }
        }
    }
    
    private func updateForSize(
        textView: UITextView,
        placeholder: UILabel?,
        size: BingoGridSize
    ) {
        placeholder?.font = gridSize.textFont
        textView.font = gridSize.textFont
        textView.textContainer.maximumNumberOfLines = gridSize.maxNumberOfLinesInTextField
    }
}

private extension BingoGridSize {
    var textFont: UIFont {
        switch self {
        case ._3x3:
            AveFont.content2_uifont
        case ._4x4:
            AveFont.content3_uifont
        }
    }
    
    var maxNumberOfLinesInTextField: Int {
        switch self {
        case ._3x3:
            5
        case ._4x4:
            4
        }
    }
}
