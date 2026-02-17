//
//  ToDoMeongApp.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/12/24.
//

import SwiftUI
import WidgetKit
import RealmSwift


@main
struct ToDoMeongApp: App {
    
    @AppStorage("themeMode") var themeMode: String = ThemeMode.system.rawValue
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    private let userDefaults = UserDefaults(suiteName: "group.com.daeyunkwon.ToDoMeong")
    private let repository = TodoRepository()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(TabViewManager.shared)
                .preferredColorScheme(getPreferredColorScheme())
        }
        .onChange(of: scenePhase) { _, newValue in
            switch newValue {
            case .active:
                refreshTodoCountWidgets()
            case .inactive, .background:
                break
            @unknown default:
                break
            }
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
    
    /// 오늘 및 내일 할 일 개수를 가져와 위젯 업데이트
    private func refreshTodoCountWidgets() {
        repository.fetchTodayTodo { result in
            switch result {
            case .success(let todos):
                self.userDefaults?.set(todos.count, forKey: "count")
                
                let calendar = Calendar.current
                
                if let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) {
                    let tomorrowStart = calendar.startOfDay(for: tomorrow)
                    
                    self.repository.fetchTodo(date: tomorrowStart) { result in
                        switch result {
                        case .success(let tomorrowTodos):
                            self.userDefaults?.set(tomorrowTodos.count, forKey: "tomorrow")
                        
                        case .failure(let error):
                            print(error.description)
                            self.userDefaults?.set(0, forKey: "tomorrow")
                        }
                        WidgetCenter.shared.reloadTimelines(ofKind: "ToDoMeongBasicWidget")
                    }
                }
                
            case .failure(let error):
                print(error.description)
            }
        }
    }
}

