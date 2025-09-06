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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(TabViewManager.shared)
                .preferredColorScheme(getPreferredColorScheme())
        }
    }
    
    init() {
        Thread.sleep(forTimeInterval: 0.65) //런치스크린 딜레이 주기
            
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "DEBUG: Realm Not Found")
    }
    
    private func getPreferredColorScheme() -> ColorScheme? {
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
