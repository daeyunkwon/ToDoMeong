//
//  UIApplication+Extension.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/16/24.
//

import UIKit

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
