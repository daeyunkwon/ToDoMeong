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
    
    var body: some View {
        TabView(selection: $tabSelection,
                content:  {
            TodoView().tag(0)
            Text("Tab Content 2").tag(1)
            Text("Tab Content 3").tag(2)
            Text("Tab Content 4").tag(3)
        })
        .overlay(alignment: .bottom) {
            CustomTabView(tabSelection: $tabSelection)
                .offset(y: 7)
        }
        .ignoresSafeArea(.keyboard)
        .onAppear() {
            UITabBar.appearance().isHidden = true
        }
    }
}

#Preview {
    MainTabView()
}
