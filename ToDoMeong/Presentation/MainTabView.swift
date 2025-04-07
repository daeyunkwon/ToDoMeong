//
//  MainTabView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/12/24.
//

import SwiftUI
import RealmSwift

struct MainTabView: View {
    
    @State private var tabSelection = 0
    @EnvironmentObject private var tabViewManager: TabViewManager
    
    var body: some View {
        TabView(selection: $tabSelection,
                content:  {
            TodoView().tag(0)
            CalendarTodoView().tag(1)
//            Text("Tab Content 3").tag(2)
            SettingView().tag(2)
        })
        .overlay(alignment: .bottom) {
            if !tabViewManager.isTabViewHidden{
                CustomTabView(tabSelection: $tabSelection)
                    .offset(y: 7)
            }
        }
        .ignoresSafeArea(.keyboard)
        .onAppear() {
            UITabBar.appearance().isHidden = true
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(TabViewManager.shared)
}


