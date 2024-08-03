import SwiftUI
import UIKit

struct BingoCellTextField: UIViewRepresentable {
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var currentlySelectedCell: Int
        
        let index: Int

        var didBecomeFirstResponder = false

        init(
            text: Binding<String>,
            currentlySelectedCell: Binding<Int>,
            index: Int
        ) {
            _text = text
            _currentlySelectedCell = currentlySelectedCell
            self.index = index
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            textField.resignFirstResponder()
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            currentlySelectedCell = index
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.text = textField.text ?? ""
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.currentlySelectedCell += 1
            return false
        }
    }

    @Binding var text: String
    @Binding var currentlySelectedCell: Int
    var isFirstResponder: Bool = false
    let index: Int

    func makeUIView(context: UIViewRepresentableContext<BingoCellTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.textAlignment = .center
        textField.keyboardType = .default
        return textField
    }

    func makeCoordinator() -> BingoCellTextField.Coordinator {
        return Coordinator(
            text: $text,
            currentlySelectedCell: $currentlySelectedCell,
            index: index
        )
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<BingoCellTextField>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}

