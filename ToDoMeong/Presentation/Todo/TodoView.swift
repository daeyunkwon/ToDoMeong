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
                
                Spacer()
                    .frame(height: 10)
                
                Text("todayTodo".localized())
                    .font(Constant.AppFont.jalnanTopLeading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .background(Color(uiColor: .systemBackground))
                    .frame(height: 20)
                
                CapsuleDateView()
                
                TodoListView(viewModel: viewModel)
                    .onDrop(of: [.text], delegate: TodoDropDelegate(viewModel: self.viewModel, shouldHandleDrop: false))
                
                .overlay(alignment: .bottomTrailing) {
                    PlusCircleButtonView(viewModel: viewModel)
                    .offset(x: -10, y: -50)
                    .buttonStyle(PlainButtonStyle())
                    .shadow(radius: 2)
                    .onDrop(of: [.text], delegate: TodoDropDelegate(viewModel: self.viewModel, shouldHandleDrop: true))
                }
                .ignoresSafeArea(.keyboard)
            }
            .overlay(alignment: .bottom, content: {
                Rectangle()
                    .fill(Color(uiColor: .systemGray6))
                    .frame(height: 50)
                    .offset(y: 50)
            })
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
        
        //새로운 할 일 추가 화면 팝업
        .popup(isPresented: $viewModel.output.showAddTodoView) {
            AddTodoView(
                isShowing: $viewModel.output.showAddTodoView,
                addSucceed: Binding(get: {
                    
                }, set: { _ in
                    viewModel.action(.showAddCompletionFeedback(type: .succeed))
                }),
                addFailed: Binding(get: {
                    
                }, set: { _ in
                    viewModel.action(.showAddCompletionFeedback(type: .failed))
                }),
                todoList: $viewModel.output.todoList,
                viewModel: AddTodoViewModel(selectedDate: nil)
            )
        } customize: {
            $0
                .type(.toast)
                .position(.center)
                .closeOnTap(false)
                .closeOnTapOutside(true)
                .dragToDismiss(true)
                .backgroundColor(.black.opacity(0.4))
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
                .closeOnTapOutside(false)
                .autohideIn(2)
                .isOpaque(false)
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
                .isOpaque(false)
        }
        
        //할 일 삭제 실패 안내 팝업
        .popup(isPresented: $viewModel.output.showFailedToDeleteToast) {
            AddEditFailToastView(type: .failedToDelete)
        } customize: {
            $0
                .type(.toast)
                .position(.top)
                .appearFrom(.topSlide)
                .closeOnTap(true)
                .closeOnTapOutside(true)
                .autohideIn(2)
                .isOpaque(false)
        }
        
        //할 일 수정 성공 안내 팝업
        .popup(isPresented: $viewModel.output.showUpdateSucceedToast) {
            AddEditCompleteToastView(type: .editTodo)
        } customize: {
            $0
                .type(.toast)
                .position(.top)
                .appearFrom(.topSlide)
                .closeOnTap(true)
                .closeOnTapOutside(true)
                .autohideIn(2)
                .isOpaque(false)
        }
        
        //할 일 수정 실패 안내 팝업
        .popup(isPresented: $viewModel.output.showUpdateFailedToast) {
            AddEditFailToastView(type: .failedToEdit)
        } customize: {
            $0
                .type(.toast)
                .position(.top)
                .appearFrom(.topSlide)
                .closeOnTap(true)
                .closeOnTapOutside(true)
                .autohideIn(2)
                .isOpaque(false)
        }
        
        .onChange(value: viewModel.output.showAddTodoView, action: { isPresented in
            if !isPresented {
                UIApplication.shared.dismissKeyboard()
            }
        })
        
        .onAppear {
            viewModel.action(.onAppear)
        }
    }
}

#Preview {
    TodoView()
}

//MARK: - 캡슐모양 오늘 날짜 뷰

private struct CapsuleDateView: View {
    var body: some View {
        UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 20, bottomTrailingRadius: 20, topTrailingRadius: 20, style: .continuous)
            .fill(.brandGreen)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .padding(.horizontal, 7)
            .overlay {
                Text(Date().dayOfTheWeekDateString)
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
            .padding(.top, 7)
    }
}

//MARK: - Todo 목록 뷰

private struct TodoListView: View {
    @ObservedObject private var viewModel: TodoViewModel
    
    fileprivate init(viewModel: TodoViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            Spacer()
            LazyVStack {
                ForEach($viewModel.output.todoList, id: \.id) { $item in
                    if !item.isInvalidated {
                        TodoRowView(todo: $item, onDone: {
                            viewModel.action(.done(target: item))
                        }, onDelete: {
                            viewModel.action(.delete(target: item))
                            
                        }, onEdit: { content, imageData in
                            viewModel.action(.edit(target: item, content: content, imageData: imageData))
                        })
                        .onDrag {
                            // todo 개수 동기화 시에만 drop delete를 handling
                            if viewModel.count == viewModel.output.todoList.count || viewModel.count == -1 {
                                HapticManager.shared.impact(style: .light)
                                viewModel.count = viewModel.output.todoList.count
                                
                                viewModel.action(.onDragging)
                                return NSItemProvider(object: String(item.id.stringValue) as NSString)
                                
                            } else {
                                // 더미 데이터를 보내 삭제 처리 방지
                                viewModel.action(.onDragging)
                                return NSItemProvider(object: String("") as NSString)
                            }
                        }
                    }
                }
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
                DogMessageBubbleView(message: "emptyTodoMessageForToday".localized())
            }
        }
    }
}

//MARK: - Todo 추가 플로팅 버튼

private struct PlusCircleButtonView: View {
    @ObservedObject private var viewModel: TodoViewModel
    
    fileprivate init(viewModel: TodoViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Button(action: {
            viewModel.action(.addButtonTapped)
        }, label: {
            Image(systemName:
                    viewModel.output.isDragging ? "trash" : "plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .clipShape(Circle())
                .padding()
                .background(
                    viewModel.output.isDragging ? Color.pink : Color.brandGreen
                )
                .scaleEffect(viewModel.output.isDragging && viewModel.output.bounce ? 1.3 : 1.0)
                .animation(viewModel.output.bounce
                    ? .easeInOut(duration: 0.5).repeatForever(autoreverses: true) : .default,
                    value: viewModel.output.bounce)
                .frame(width: 54, height: 54)
                .clipShape(Circle())
                .padding()
                .padding(.bottom, 15)
        })
    }
}
