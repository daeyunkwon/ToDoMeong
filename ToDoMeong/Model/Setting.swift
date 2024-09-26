//
//  Setting.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/25/24.
//

import Foundation

enum SettingButtonType: Equatable, Hashable {
    case navigationLink
    case toggle
    case button(detailType: SettingButtonDetailType)
}

enum SettingButtonDetailType: Equatable, Hashable {
    case sendMail
}

struct Setting: Hashable, Identifiable {
    let id = UUID().uuidString
    let title: String
    let type: SettingButtonType
}


