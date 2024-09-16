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
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
    
    init() {
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "DEBUG: Realm Not Found")
    }
}
