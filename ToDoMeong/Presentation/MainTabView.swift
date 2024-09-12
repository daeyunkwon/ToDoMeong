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
            ContentView()
                .tabItem {
                    Image(systemName: "checklist")
                    Text("할 일")
                }
        }
        .tint(.black)
        
    }
}

#Preview {
    MainTabView()
}
