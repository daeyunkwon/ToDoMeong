//
//  DogMessageBubbleView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/16/24.
//

import SwiftUI

struct DogMessageBubbleView: View {
    let message: String
    
    var body: some View {
        VStack {
            
            Text(message)
                .font(Constant.AppFont.tmoneyRoundWindRegular14)
                .multilineTextAlignment(.center)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color(uiColor: .systemBackground))
                        .shadow(color: .black.opacity(0.12), radius: 10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(.white, lineWidth: 1)
                        }
                }
            
            Image("dog", bundle: nil)
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 90)
                .padding(.top, 0)
        }
    }
}

#Preview {
    DogMessageBubbleView(message: "오늘은 어떤 일을 해야 하나요?\n새로운 할 일을 추가해 보세요")
}
