//
//  SettingView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/23/24.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        NavigationStack {
            
            
            List {
                Section {
                    Text("tt")
                    Text("tt")
                    Text("tt")
                    Text("tt")
                }
                
                
                Section {
                    Text("tt")
                    Text("tt")
                    Text("tt")
                    Text("tt")
                }
                
                
            }
            
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("설정")
                        .font(Constant.AppFont.jalnanTopLeading)
                        .padding(.top, 15)
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
