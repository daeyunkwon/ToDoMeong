//
//  CalendarTodoView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/19/24.
//

import SwiftUI
import RealmSwift

struct CalendarTodoView: View {
    
    @StateObject private var viewModel = CalendarTodoViewModel()

    
    var body: some View {
        
        NavigationStack {
            
            Text(viewModel.output.currentPageDate.yearMonthDateString)
                .bold()
                .frame(maxWidth: .infinity)
                .overlay {
                    Button(action: {
                        viewModel.action(.todayButtonTapped)
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
            
            FSCalendarView(selectedDate: Binding(get: {
                viewModel.output.selectedDate
            }, set: { newDate in
                viewModel.action(.selectedDate(date: newDate))
            }), currentPageDate: Binding(get: {
                viewModel.output.currentPageDate
            }, set: { newPageDate in
                viewModel.action(.updateCurrentPageDate(date: newPageDate))
            }), moveToday: $viewModel.output.moveToday, isImageUpdate: $viewModel.output.isImageUpdate)
                .frame(height: 300)
            
            ScrollView {
                Text("")
                Text(viewModel.output.selectedDate.dayOfTheWeekDateString)
                    .font(.system(size: 13, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)
                    .background(Color(uiColor: .systemGray6))
                ForEach($viewModel.output.selectedDateTodoList, id: \.id) { $item in
                    
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
        
        
        
        
    }
    
    
}

#Preview {
    CalendarTodoView()
}
