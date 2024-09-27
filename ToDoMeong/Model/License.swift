//
//  License.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/27/24.
//

import Foundation

struct License: Hashable, Identifiable {
    let id = UUID().uuidString
    let name: String
    let copyright: String
    let url: String
}

extension License {
    static let list: [License] = [
        License(name: "FSCalendar", copyright: "Copyright (c) 2013-2016 FSCalendar", url: "https://github.com/WenchaoD/FSCalendar"),
        License(name: "PopupView", copyright: "Copyright (c) 2019 exyte <info@exyte.com>", url: "https://github.com/exyte/PopupView"),
        License(name: "Realm", copyright: "Copyright (c) 2011-present, MongoDB, Inc. and Realm contributors", url: "https://github.com/realm/realm-swift")
    ]
}
