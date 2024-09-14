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
            VStack(alignment: .leading) {
                UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 20, bottomTrailingRadius: 20, topTrailingRadius: 20, style: .continuous)
                    .fill(.brandGreen)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .overlay {
                        Text(Date().dateString)
                            .font(Constant.AppFont.jalnan13)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 15)
                            .background(.clear)
                    }
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 20, bottomTrailingRadius: 20, topTrailingRadius: 0, style: .continuous))
                    .padding(.vertical, -4)
                    .padding(.horizontal, 5)
                    .offset(y: 3)
                    .shadow(radius: 1.5)
                
                ScrollView {
                    Spacer()
                    ForEach(todoList, id: \.self) { item in
                        TodoRowView(text: item)
                    }
                }
                .frame(maxWidth: .infinity)
                .safeAreaInset(edge: .bottom, content: {
                    Color.clear.frame(height: 80)
                })
                .background(Color(uiColor: .systemGray6))
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 20, style: .continuous))
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
                    .offset(x: -10, y: -50)
                    .buttonStyle(PlainButtonStyle())
                    .shadow(radius: 2)
                }
                
            }
            
            
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("오늘 할 일")
                        .font(Constant.AppFont.jalnanTopLeading)
                }
            }
            
            
            .background(Color(uiColor: .systemGray6))
        }
    }
}

#Preview {
    TodoView()
}
