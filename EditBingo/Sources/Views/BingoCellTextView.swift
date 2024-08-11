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
//            onPreferredHeightUpdated(textView.sizeThatFits(textView.frame.size).height)
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
        let textView = CustomTextView(onPreferredHeightUpdated: onPreferredHeightUpdated)
        
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Type text\nhere"
        placeholderLabel.numberOfLines = 2
        placeholderLabel.textAlignment = .center
        placeholderLabel.font = gridSize.textUIFont
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
        
        textView.font = gridSize.textUIFont
        textView.tintColor = UIColor(AveColor.content)
        textView.textContainer.maximumNumberOfLines = gridSize.maxNumberOfLinesInTextField
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
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
    }
    
    private func updateForSize(
        textView: UITextView,
        placeholder: UILabel?,
        size: BingoGridSize
    ) {
        placeholder?.font = gridSize.textUIFont
        textView.font = gridSize.textUIFont
        textView.textContainer.maximumNumberOfLines = gridSize.maxNumberOfLinesInTextField
    }
}

private final class CustomTextView: UITextView {
    let onPreferredHeightUpdated: (CGFloat) -> Void
    
    init(onPreferredHeightUpdated: @escaping (CGFloat) -> Void) {
        self.onPreferredHeightUpdated = onPreferredHeightUpdated
        super.init(frame: .zero, textContainer: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let newHeight = sizeThatFits( .init(width: frame.size.width, height: .infinity)).height
        onPreferredHeightUpdated(newHeight)
    }
}
