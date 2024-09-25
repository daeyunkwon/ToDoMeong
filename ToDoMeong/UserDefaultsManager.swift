//
//  UserDefaultsManager.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/25/24.
//

import UIKit
import SwiftUI

@propertyWrapper
struct UserDefaultsPropertyWrapper<T> {
    let key: String
    let defaultValue: T
    var storage: UserDefaults
    
    var wrappedValue: T {
        get {
            return self.storage.object(forKey: self.key) as? T ?? self.defaultValue
        }
        set {
            return self.storage.set(newValue, forKey: self.key)
        }
    }
}

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private init() {}
    
    enum Key: String, CaseIterable {
        case themeMode
    }
    
    @UserDefaultsPropertyWrapper(key: Key.themeMode.rawValue, defaultValue: nil, storage: UserDefaults.standard)
    var themeMode: String?
}
