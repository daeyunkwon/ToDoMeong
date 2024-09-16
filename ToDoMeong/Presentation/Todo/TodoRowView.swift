//
//  TodoRowView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/13/24.
//

import SwiftUI
import RealmSwift

struct TodoRowView: View {
    
    @ObservedRealmObject var todo: Todo
    
    var body: some View {
        
        VStack {
            HStack(spacing: 0) {
                Spacer()
                
                //체크박스 영역
                Button(action: {
                    $todo.done.wrappedValue.toggle()
                    HapticManager.shared.impact(style: .light)
                }, label: {
                    Image(todo.done ? "checkbox_completion" : "checkbox", bundle: nil)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                })
                
                //내용 영역
                Button(action: {
                    print(2222)
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
                Button("Test") {
                    print(3333)
                }
                .foregroundStyle(.red)
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
    }
}
