//
//  MainTabView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/12/24.
//

import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        TabView {
            TodoView()
                .tabItem {
                    Image(systemName: "checklist")
                    Text("할 일")
                }
                
        }
        .tint(Color(uiColor: UIColor.label))
        .onAppear() {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = .systemBackground
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    MainTabView()
}
