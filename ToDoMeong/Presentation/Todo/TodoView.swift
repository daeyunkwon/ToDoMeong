//
//  ContentView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/12/24.
//

import SwiftUI
import PopupView
import RealmSwift

struct TodoView: View {
    
    @StateObject private var viewModel = TodoViewModel()
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                
                UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 20, bottomTrailingRadius: 20, topTrailingRadius: 20, style: .continuous)
                    .fill(.brandGreen)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .padding(.horizontal, 7)
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
                    ForEach(viewModel.output.todoList, id: \.self) { item in
                        TodoRowView(todo: item)
                    }
                }
                .frame(maxWidth: .infinity)
                .safeAreaInset(edge: .bottom, content: {
                    Color.clear.frame(height: 80)
                })
                .background(Color(uiColor: .systemGray6))
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 20, style: .continuous))
                
                .overlay {
                    if viewModel.output.todoList.isEmpty {
                        DogMessageBubbleView(message: "오늘은 어떤 일을 해야 하나요?\n새로운 할 일을 추가해 보세요🐾")
                    }
                }
                
                .overlay(alignment: .bottomTrailing) {
                    Button(action: {
                        viewModel.output.showAddTodoView = true
                    }, label: {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 24, height: 24)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .clipShape(Circle())
                            .padding()
                            .background(Color.brandGreen)
                            .frame(width: 54, height: 54)
                            .clipShape(Circle())
                            .padding()
                    })
                    .offset(x: -10, y: -50)
                    .buttonStyle(PlainButtonStyle())
                    .shadow(radius: 2)
                }
                .ignoresSafeArea(.keyboard)
            }
            .overlay(alignment: .bottom, content: {
                Rectangle()
                    .fill(Color(uiColor: .systemGray6))
                    .frame(height: 50)
                    .offset(y: 50)
            })
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("오늘 할 일")
                        .font(Constant.AppFont.jalnanTopLeading)
                }
            }
        }
        
        //새로운 할 일 추가 화면 팝업
        .popup(isPresented: $viewModel.output.showAddTodoView) {
            AddTodoView(isShowing: $viewModel.output.showAddTodoView, isAddNewTodo: $viewModel.output.isAddNewTodo, isFailedToAdd: $viewModel.output.isFailedAddTodo, todoList: $viewModel.output.todoList)
        } customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .closeOnTap(false)
                .closeOnTapOutside(true)
                .dragToDismiss(true)
                .backgroundColor(.black.opacity(0.4))
                .useKeyboardSafeArea(true)
                .isOpaque(true)
        }
        
        //새로운 할 일 추가 성공 안내 팝업
        .popup(isPresented: $viewModel.output.showAddNewCompletionToast) {
            AddEditCompleteToastView(type: .addNewTodo)
        } customize: {
            $0
                .type(.toast)
                .position(.top)
                .appearFrom(.topSlide)
                .closeOnTap(true)
                .closeOnTapOutside(true)
                .autohideIn(2)
                .isOpaque(true)
        }
        
        //새로운 할 일 추가 실패 안내 팝업
        .popup(isPresented: $viewModel.output.showFailedToAddToast) {
            AddEditFailToastView(type: .failedToAdd)
        } customize: {
            $0
                .type(.toast)
                .position(.top)
                .appearFrom(.topSlide)
                .closeOnTap(true)
                .closeOnTapOutside(true)
                .autohideIn(2)
                .isOpaque(true)
        }
        
        .onChange(value: viewModel.output.showAddTodoView, action: { isPresented in
            if !isPresented {
                UIApplication.shared.dismissKeyboard()
            }
        })
        
        //새로운 할 일 추가 팝업 띄우기
        .onChange(value: viewModel.output.isAddNewTodo) { isAdd in
            if isAdd {
                viewModel.output.isAddNewTodo = false
                viewModel.output.showAddNewCompletionToast = true
                HapticManager.shared.impact(style: .light)
            }
        }
        
        //새로운 할 일 추가 실패 팝업 띄우기
        .onChange(value: viewModel.output.isFailedAddTodo) { isFailed in
            if isFailed {
                viewModel.output.isFailedAddTodo = false
                viewModel.output.showFailedToAddToast = true
                HapticManager.shared.impact(style: .light)
            }
        }
        
        
        .onAppear {
            viewModel.action(.onAppear)
        }
    }
    
    
}

#Preview {
    TodoView()
}
