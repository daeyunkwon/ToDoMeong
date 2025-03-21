//
//  CustomUIKitTextField.swift
//  ToDoMeong
//
//  Created by 권대윤 on 3/21/25.
//

import SwiftUI

struct CustomUIKitTextField: UIViewRepresentable {
    @Binding var text: String

    final class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomUIKitTextField

        init(_ parent: CustomUIKitTextField) {
            self.parent = parent
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            return false // 키보드 닫힘을 막음
        }
        
        @objc func textChanged(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }

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
