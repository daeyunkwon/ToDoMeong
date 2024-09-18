//
//  EditTodoView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/17/24.
//

import SwiftUI

struct EditTodoView: View {
    
    @StateObject var viewModel: EditTodoViewModel
    
    var body: some View {
        VStack {
            ZStack(alignment: .trailing) {
                self.textFieldView
            }
            .padding(.bottom, 5)
            
            photoButtonView
            
            HStack {
                self.saveButtonView
                self.deleteButtonView
            }
        }
        .frame(height: 230)
        .background {
            Rectangle()
                .fill(Color(uiColor: .systemBackground))
                .clipShape(.rect(topLeadingRadius: 40, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 40, style: .continuous))
            Rectangle()
                .fill(Color(uiColor: .systemBackground))
                .clipShape(.rect(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 0, style: .continuous))
                .offset(y: 50)
        }
    }
    
    @ViewBuilder private var textFieldView: some View {
        TextField("내용을 입력해 주세요", text: Binding(get: {
            viewModel.output.text
        }, set: { newValue in
            viewModel.input.text.send(newValue)
        }))
        .font(.system(size: 14))
        .padding()
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
    
    private var photoButtonView: some View {
        Button(action: {
            
        }, label: {
            Image("add_image", bundle: nil)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .tint(.skyblue)
            Text("사진 추가하기")
                .tint(Color(uiColor: .label))
                .font(.system(size: 14))
            Spacer()
        })
        .padding(.leading, 25)
        .padding(.bottom, 15)
    }
    
    private var saveButtonView: some View {
        Button(action: {
            //viewModel.input.addButtonTapped.send(())
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: 50)
                    .foregroundStyle(.skyblue)
                Text("저장")
                    .font(Constant.AppFont.tmoneyRoundWindExtraBold15)
                    .foregroundStyle(.white)
            }
        })
        .padding(.leading, 15)
        .buttonStyle(PlainButtonStyle())
        .disabled(viewModel.output.text.trimmingCharacters(in: .whitespaces).isEmpty ? true : false)
    }
    
    private var deleteButtonView: some View {
        Button(action: {
            viewModel.action(.deleteButtonTapped)
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: 50)
                    .foregroundStyle(.customPink)
                Text("삭제")
                    .font(Constant.AppFont.tmoneyRoundWindExtraBold15)
                    .foregroundStyle(.white)
            }
        })
        .padding(.trailing, 15)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    EditTodoView(viewModel: EditTodoViewModel(todoItem: Todo(content: "dummy"), isPresented: .constant(true), onDelete: {
        
    }))
}
