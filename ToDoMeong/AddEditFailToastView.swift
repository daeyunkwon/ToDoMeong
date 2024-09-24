//
//  AddEditFailToastView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/17/24.
//

import SwiftUI

struct AddEditFailToastView: View {
    enum ToastType {
        case failedToAdd
        case failedToEdit
        case failedToDelete
        case failedToLoad
    }
    var type: ToastType
    
    var body: some View {
        HStack {
            Image("xmark_circle")
                .resizable()
                .scaledToFill()
                .frame(width: 62, height: 62)
            
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
        .background(.customPink)
    }
    
    private var title: String {
        return "issueOccurred".localized()
    }
    
    private var message: String {
        switch type {
        case .failedToAdd:
            return "failedToAddMessage".localized()
        case .failedToEdit:
            return "failedToEditMessage".localized()
        case .failedToDelete:
            return "failedToDeleteMessage".localized()
        case .failedToLoad:
            return "failedToLoadMessage".localized()
        }
    }
}

#Preview {
    AddEditFailToastView(type: .failedToAdd)
}
