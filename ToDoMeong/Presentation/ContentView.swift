//
//  ContentView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Text("테스트")
            
            
            
            
            
            
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("오늘 할 일")
                            .font(Constant.AppFont.jalnanBold23)
                            
                    }
                }
        }
       
        
    }
    
    init() {
        
        for fontFamily in UIFont.familyNames {
            for fontName in UIFont.fontNames(forFamilyName: fontFamily) {
                print(fontName)
            }
        }
        
    }
    
}

#Preview {
    ContentView()
}
