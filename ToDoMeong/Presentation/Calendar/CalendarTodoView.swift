//
//  CalendarTodoView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/19/24.
//

import SwiftUI
import RealmSwift

struct CalendarTodoView: View {
    
    @State private var selectedDate: Date = Date()
    @State private var currentPageDate: Date = Date()
    @State private var moveToday = false
    @State var todoList: [Todo] = []
    @State private var isImageUpdate = false

    
    var body: some View {
        
        NavigationStack {
            
            Text(currentPageDate.yearMonthDateString)
                .bold()
                .frame(maxWidth: .infinity)
                .overlay {
                    Button(action: {
                        moveToday = true
                    }, label: {
                        Text("오늘")
                            .font(.system(size: 12, weight: .medium))
                            .padding(5)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(lineWidth: 2.0)
                            }
                            .tint(.brandGreen)
                    })
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 15)
                }
            
            FSCalendarView(selectedDate: $selectedDate, currentPageDate: $currentPageDate, moveToday: $moveToday, isImageUpdate: $isImageUpdate)
                .frame(height: 300)
            
            ScrollView {
                Text("")
                Text(selectedDate.dayOfTheWeekDateString)
                    .font(.system(size: 13, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)
                    .background(Color(uiColor: .systemGray6))
                ForEach($todoList, id: \.id) { $item in
                    
                    TodoRowView(todo: $item) {
                        
                    } onDelete: {
                        
                    } onEdit: { content, imageData in
                        
                    }
                }
                Text("")
                    .frame(height: 100)
            }
            .background(Color(uiColor: .systemGray6))
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("캘린더")
                        .font(Constant.AppFont.jalnanTopLeading)
                }
            }
        }
        
//        .onChange(value: selectedDate) { value in
//            let repo = TodoRepository()
//            self.todoList = repo.fetchTodo(date: self.selectedDate)
//            print(selectedDate)
//            print(todoList)
//        }
        
        .onChange(value: todoList, action: { _ in
            isImageUpdate = true
        })
        
        
        .onAppear {
            let repo = TodoRepository()
            self.todoList = repo.fetchTodo(date: self.selectedDate)
            print(todoList)
            print("갱신")
        }
        
        
        
        
    }
    
    
}

#Preview {
    CalendarTodoView()
}
