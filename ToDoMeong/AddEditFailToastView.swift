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
        return "문제 발생"
    }
    
    private var message: String {
        switch type {
        case .failedToAdd:
            return "새로운 할 일 추가가 실패되었습니다.\n잠시 후 다시 시도해 주세요."
        case .failedToEdit:
            return "수정이 실패되었습니다.\n잠시 후 다시 시도해 주세요."
        case .failedToDelete:
            return "삭제가 실패되었습니다.\n잠시 후 다시 시도해 주세요."
        case .failedToLoad:
            return "저장된 할 일 목록 불러오기가 실패되었습니다.\n잠시 후 다시 시도해 주세요."
        }
    }
}

#Preview {
    AddEditFailToastView(type: .failedToAdd)
}
