//
//  TodoEditView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/14/24.
//

import SwiftUI
import RealmSwift

struct AddTodoView: View {
    
    //MARK: - Properties
    
    @Binding var isShowing: Bool
    @Binding var isAddNewTodo: Bool
    @Binding var isFailedToAdd: Bool
    
    @Binding var todoList: [Todo]
    
    @StateObject var viewModel: AddTodoViewModel

    //MARK: - Body
    
    var body: some View {
        VStack {
            Text("addNewTodo".localized())
                .font(.headline)
            
            self.textFieldView()
            
            self.addButtonView()
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
        
        .onReceive(viewModel.output.addTodoResult, perform: { result in
                switch result {
                case .success(let todo):
                    self.todoList.append(todo)
                    isShowing = false
                    isAddNewTodo = true
                
                case .failure(let error):
                    print(error)
                    isShowing = false
                    isFailedToAdd = true
                }
        })
    }
    
    //MARK: - Methods
    
    private func textFieldView() -> some View {
        ZStack(alignment: .trailing) {
            TextField("textFieldPlaceholder", text: Binding(get: {
                viewModel.output.text
            }, set: { newValue in
                viewModel.input.text.send(newValue)
            }))
            .font(.system(size: 14))
            .padding()
            .padding(.trailing, viewModel.output.text.isEmpty ? 10 : 20)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color(uiColor: .systemGray6))
            .clipShape(.rect(cornerRadius: 15))
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.clear, lineWidth: 2)
            )
            .padding(.horizontal, 15)
            
            if !viewModel.output.text.isEmpty {
                Button(action: {
                    viewModel.input.text.send("")
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 20)
                }
            }
        }
        .padding(.top, 15)
    }
    
    private func addButtonView() -> some View {
        Button(action: {
            viewModel.input.addButtonTapped.send(())
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: 50)
                    .foregroundStyle(.brandGreen)
                Text("add".localized())
                    .font(Constant.AppFont.tmoneyRoundWindExtraBold15)
                    .foregroundStyle(.white)
            }
        })
        .padding(.horizontal, 15)
        .buttonStyle(PlainButtonStyle())
        .disabled(isAddButtonDisabled())
    }
    
    private func isAddButtonDisabled() -> Bool {
        if !viewModel.output.text.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        } else {
            return true
        }
    }
}

#Preview {
    AddTodoView(isShowing: .constant(true), isAddNewTodo: .constant(false), isFailedToAdd: .constant(false), todoList: .constant([]), viewModel: AddTodoViewModel(selectedDate: nil))
}
