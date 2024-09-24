//
//  String+Extension.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/24/24.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
