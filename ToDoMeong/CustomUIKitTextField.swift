//
//  CustomUIKitTextField.swift
//  ToDoMeong
//
//  Created by 권대윤 on 3/21/25.
//

import SwiftUI

struct CustomUIKitTextField: UIViewRepresentable {
    @Binding var text: String
    var onReturnKeyTapped: (() -> Void)?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.borderStyle = .none
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.font = .systemFont(ofSize: 14)
        textField.placeholder = NSLocalizedString("textFieldPlaceholder", comment: "")
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textChanged), for: .editingChanged)
        textField.becomeFirstResponder()
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}

//MARK: - Coordinator

extension CustomUIKitTextField {
    final class Coordinator: NSObject, UITextFieldDelegate {
        private let parent: CustomUIKitTextField

        init(_ parent: CustomUIKitTextField) {
            self.parent = parent
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if parent.text.isEmpty {
                return false
            } else {
                textField.resignFirstResponder()
                parent.onReturnKeyTapped?()
                return true
            }
        }
        
        @objc func textChanged(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}
