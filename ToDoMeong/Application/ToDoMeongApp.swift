//
//  ToDoMeongApp.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/12/24.
//

import SwiftUI
import RealmSwift

@main
struct ToDoMeongApp: App {
    
    @AppStorage("themeMode") var themeMode: String = ThemeMode.system.rawValue
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(getPreferredColorScheme())
        }
    }
    
    init() {
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "DEBUG: Realm Not Found")
    }
    
    func getPreferredColorScheme() -> ColorScheme? {
        switch themeMode {
        case ThemeMode.dark.rawValue:
            return .dark
        case ThemeMode.light.rawValue:
            return .light
        default:
            return nil
        }
    }
}
