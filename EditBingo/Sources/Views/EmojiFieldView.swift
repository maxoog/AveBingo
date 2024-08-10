import Foundation
import SwiftUI
import UIKit
import SharedUI

final class EmojiInputField: UIView, UIKeyInput {
    @Binding var text: String
    let imageView: UIImageView
    let backgroundView = UIView()
    
    private let defaultImage = UIImage(named: "emoji_placeholder", in: .assets, with: .none)
    
    var hasText: Bool {
        !text.isEmpty
    }
    
    override var canBecomeFirstResponder: Bool {
        true
    }
    
    override func becomeFirstResponder() -> Bool {
        backgroundView.layer.borderWidth = 1
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        backgroundView.layer.borderWidth = 0
        return super.resignFirstResponder()
    }
    
    override func draw(_ rect: CGRect) {
        guard !text.isEmpty else {
            imageView.image = defaultImage
            return
        }
        
        imageView.image = text.toUIImage()
    }
    
    init(text: Binding<String>) {
        _text = text

        let image = defaultImage
        self.imageView = UIImageView(image: image)
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: .init())
        
        self.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(imageView)
        backgroundView.layer.cornerRadius = 50
        backgroundView.layer.borderColor = UIColor(AveColor.content).cgColor
        backgroundView.backgroundColor = UIColor(AveColor.backgroundLight)
        
        NSLayoutConstraint.activate([
            backgroundView.heightAnchor.constraint(equalToConstant: 100),
            backgroundView.widthAnchor.constraint(equalToConstant: 100),
            
            imageView.heightAnchor.constraint(equalToConstant: 56),
            imageView.widthAnchor.constraint(equalToConstant: 56),
            
            imageView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func insertText(_ text: String) {
        self.text = text.last?.description ?? ""
        setNeedsDisplay()
    }
    
    func deleteBackward() {
        self.text = ""
        setNeedsDisplay()
    }
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}

struct EmojiFieldView: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> EmojiInputField {
        let emojiField = EmojiInputField(text: $text)
        return emojiField
    }
    
    func updateUIView(_ uiView: EmojiInputField, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    final class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiFieldView
        
        init(parent: EmojiFieldView) {
            self.parent = parent
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async { [weak self] in
                self?.parent.text = textField.text ?? ""
            }
        }
    }
}
