//
//  TodoRowView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/13/24.
//

import SwiftUI
import PopupView
import RealmSwift

struct TodoRowView: View {
    
    @Binding var todo: Todo
    @State private var showEditView: Bool = false
    @State private var showDetailPhotoView: Bool = false
    
    var onDone: () -> Void //완료 이벤트 트리거
    var onDelete: () -> Void //삭제 이벤트 트리거
    var onEdit: (String, Data?) -> Void //수정 이벤트 트리거
    
    init(todo: Binding<Todo>, onDone: @escaping () -> Void, onDelete: @escaping () -> Void, onEdit: @escaping (String, Data?) -> Void) {
        self._todo = todo // @Binding은 _를 붙여서 초기화
        self.onDone = onDone
        self.onDelete = onDelete
        self.onEdit = onEdit
        
        print("로우 뷰 인잇")
    }
    
    var body: some View {
        
        VStack {
            HStack(spacing: 0) {
                Spacer()
                
                //체크박스 영역
                Button(action: {
                    onDone()
                    HapticManager.shared.impact(style: .light)
                }, label: {
                    Image(todo.done ? "checkbox_completion" : "checkbox", bundle: nil)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                })
                
                //내용 영역
                Button(action: {
                    showEditView = true
                }, label: {
                    Text(todo.content)
                        .font(Constant.AppFont.tmoneyRoundWindRegular14)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                })
                .tint(Color(uiColor: UIColor.label))
                    
                //이미지 영역
                Button {
                    if todo.photo != nil {
                        showDetailPhotoView.toggle()
                    }
                } label: {
                    Image(uiImage: ImageFileManager.shared.loadImageToDocument(filename: todo.id.stringValue) ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(.rect(cornerRadius: 10))
                }
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 7)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.clear)
                    .background(.background)
                    .clipShape(.rect(cornerRadius: 15))
            }
            .padding(.horizontal, 15)
        }
        
        .popup(isPresented: $showEditView) {
            EditTodoView(viewModel: EditTodoViewModel(todoItem: self.todo, onDelete: {
                showEditView = false
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    if !todo.isInvalidated {
                        self.onDelete()
                    }
                }
            }, onEdit: { content, imageData in
                showEditView = false
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    if !todo.isInvalidated {
                        self.onEdit(content, imageData)
                    }
                }
            }), isPresented: $showEditView)
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
        
        .onChange(value: showEditView) { value in
            if !value {
                UIApplication.shared.dismissKeyboard()
            }
        }
        
        .sheet(isPresented: $showDetailPhotoView, content: {
            DetailPhotoView(todoID: todo.id.stringValue)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        })
    }
}
