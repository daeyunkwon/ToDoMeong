//
//  CalendarTodoView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/19/24.
//

import SwiftUI
import PopupView

struct CalendarTodoView: View {
    
    @StateObject private var viewModel = CalendarTodoViewModel()

    
    var body: some View {
        
        NavigationStack {
            
            Text(viewModel.output.currentPageDate.yearMonthDateString)
                .bold()
                .frame(maxWidth: .infinity)
                .overlay {
                    Button(action: {
                        viewModel.action(.movePreviousMonth)
                    }, label: {
                        self.triangleImage(rotation: -90)
                    })
                    .offset(x: -70)
                    Button(action: {
                        viewModel.action(.moveNextMonth)
                    }, label: {
                        self.triangleImage(rotation: 90)
                    })
                    .offset(x: 73)
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
            }), moveToday: $viewModel.output.moveToday, isImageUpdate: $viewModel.output.isImageUpdate, movePreviousMonth: $viewModel.output.moveToPreviousMonth, moveNextMonth: $viewModel.output.moveToNextMonth)
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
                        viewModel.action(.onDone(target: item))
                    } onDelete: {
                        viewModel.action(.onDelete(target: item))
                    } onEdit: { content, imageData in
                        viewModel.action(.onEdit(target: item, content: content, imageData: imageData))
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
        
        .popup(isPresented: $viewModel.output.showSucceedToast.0, view: {
            switch viewModel.output.showSucceedToast.1 {
            case .addNewTodo: AddEditCompleteToastView(type: .addNewTodo)
            case .editTodo: AddEditCompleteToastView(type: .editTodo)
            }
        }, customize: {
            $0
                .type(.toast)
                .position(.top)
                .appearFrom(.topSlide)
                .closeOnTap(true)
                .closeOnTapOutside(false)
                .autohideIn(2)
                .isOpaque(false)
        })
        
        .popup(isPresented: $viewModel.output.showFailedToast.0, view: {
            switch viewModel.output.showFailedToast.1 {
            case .failedToAdd: AddEditFailToastView(type: .failedToAdd)
            case .failedToDelete: AddEditFailToastView(type: .failedToDelete)
            case .failedToEdit: AddEditFailToastView(type: .failedToEdit)
            case .failedToLoad: AddEditFailToastView(type: .failedToLoad)
            }
        }, customize: {
            $0
                .type(.toast)
                .position(.top)
                .appearFrom(.topSlide)
                .closeOnTap(true)
                .closeOnTapOutside(false)
                .autohideIn(2)
                .isOpaque(false)
        })
    }
    
    private func triangleImage(rotation: Double) -> some View {
        Image(systemName: "triangle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 15, height: 15)
            .rotationEffect(.degrees(rotation))
            .tint(.brandGreen)
    }
}

#Preview {
    CalendarTodoView()
}
