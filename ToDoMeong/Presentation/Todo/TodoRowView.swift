//
//  TodoRowView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/13/24.
//

import SwiftUI

struct TodoRowView: View {
    
    let text: String
    
    var body: some View {
        
        VStack {
            HStack(spacing: 0) {
                Spacer()
                
                Button(action: {
                    print(1111)
                    HapticManager.shared.impact(style: .light)
                }, label: {
                    Image("checkbox", bundle: nil)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                })
                
                Button(action: {
                    print(2222)
                }, label: {
                    Text(text)
                        .font(Constant.AppFont.tmoneyRoundWindRegular14)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                })
                .tint(Color(uiColor: UIColor.label))
                    
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

#Preview {
    TodoRowView(text: "test")
}
