//
//  Setting.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/25/24.
//

import Foundation

enum SettingButtonType: Equatable, Hashable {
    case navigationLink(detailType: SettingNavigationLinkDetailType)
    case toggle
    case button(detailType: SettingButtonDetailType)
}

enum SettingNavigationLinkDetailType : Equatable, Hashable {
    case theme
}

enum SettingButtonDetailType: Equatable, Hashable {
    case sendMail
    case appVersion
}

struct Setting: Hashable, Identifiable {
    let id = UUID().uuidString
    let title: String
    let type: SettingButtonType
}


