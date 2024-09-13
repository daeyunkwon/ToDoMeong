//
//  ContentView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/12/24.
//

import SwiftUI

struct TodoView: View {
    
    var todoList = Array(repeating: "할일 할일", count: 50)
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Text(Date().dateString)
                    .font(Constant.AppFont.jalnan13)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
                ScrollView {
                    Spacer()
                    ForEach(todoList, id: \.self) { item in
                        TodoRowView(text: item)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .overlay(alignment: .bottomTrailing) {
                    Button(action: {
                        print("할일 추가 버튼 탭")
                    }, label: {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .clipShape(Circle())
                            .padding()
                            .background(Color.brandGreen)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .padding()
                    })
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("오늘 할 일")
                        .font(Constant.AppFont.jalnanTopLeading)
                }
            }
            
            
                
        }
       
        
    }
    
}

#Preview {
    TodoView()
}
