//
//  TodoEditView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/14/24.
//

import SwiftUI
import RealmSwift

struct AddTodoView: View {
    
    @Binding var isShowing: Bool
    @Binding var isAddNewTodo: Bool
    @State private var inputText: String = ""
    @ObservedResults(Todo.self) var todoList
    
    var body: some View {
        VStack {
            Text("새로운 할 일 추가하기")
                .font(.headline)
            
            ZStack(alignment: .trailing) {
                TextField("내용을 입력해 주세요", text: $inputText)
                .font(.system(size: 14))
                .padding()
                .padding(.trailing, inputText.isEmpty ? 10 : 20)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color(uiColor: .systemGray6))
                .clipShape(.rect(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.clear, lineWidth: 2)
                )
                .padding(.horizontal, 15)
                
                if !inputText.isEmpty {
                    Button(action: {
                        inputText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing, 20)
                    }
                }
            }
            .padding(.top, 15)
            
            Button(action: {
                //새로운 할 일 추가
                self.addNewTodo {
                    isShowing = false
                    isAddNewTodo = true
                }
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(height: 50)
                        .foregroundStyle(.brandGreen)
                    Text("추가하기")
                        .font(Constant.AppFont.tmoneyRoundWindExtraBold15)
                        .foregroundStyle(.white)
                }
            })
            .padding(.horizontal, 15)
            .buttonStyle(PlainButtonStyle())
            .disabled(isAddButtonDisabled())
        }
        .padding()
        .background {
            Rectangle()
                .fill(Color(uiColor: .systemBackground))
                .clipShape(.rect(topLeadingRadius: 40, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 40, style: .continuous))
            Rectangle()
                .fill(Color(uiColor: .systemBackground))
                .clipShape(.rect(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 0, style: .continuous))
                .offset(y: 50)
        }
        .onTapGesture {
            UIApplication.shared.dismissKeyboard()
        }
        
    }
    
    private func isAddButtonDisabled() -> Bool {
        if !inputText.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        } else {
            return true
        }
    }
    
    private func addNewTodo(completion: @escaping () -> Void) {
        let newTodo = Todo(content: self.inputText)
        self.$todoList.append(newTodo)
        completion()
    }
}

#Preview {
    AddTodoView(isShowing: .constant(true), isAddNewTodo: .constant(false))
}
