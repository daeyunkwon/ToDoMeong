//
//  Setting.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/25/24.
//

import Foundation

enum SettingButtonType {
    case navigationLink
    case toggle
    case button
}

struct Setting: Hashable, Identifiable {
    let id = UUID().uuidString
    let title: String
    let type: SettingButtonType
}


