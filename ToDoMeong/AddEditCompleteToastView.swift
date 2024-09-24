//
//  ToastTop.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/16/24.
//

import SwiftUI

struct AddEditCompleteToastView: View {
    
    enum ToastType {
        case addNewTodo
        case editTodo
    }
    var type: ToastType
    
    var body: some View {
        HStack {
            Image("checkmark_circle")
                .frame(width: 48, height: 48)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    Spacer()
                }
                
                Text(message)
                    .font(.system(size: 15, weight: .light))
            }
        }
        .foregroundColor(.white)
        .padding(EdgeInsets(top: 56, leading: 16, bottom: 16, trailing: 16))
        .frame(maxWidth: .infinity)
        .background(.skyblue)
    }
    
    private var title: String {
        switch type {
        case .addNewTodo:
            return "addNewTodo".localized()
        case .editTodo:
            return "editExistingTodo".localized()
        }
    }
    
    private var message: String {
        switch type {
        case .addNewTodo:
            return "addNewTodoMessage".localized()
        case .editTodo:
            return "editTodoMessage".localized()
        }
    }
}

#Preview {
    AddEditCompleteToastView(type: .addNewTodo)
}
