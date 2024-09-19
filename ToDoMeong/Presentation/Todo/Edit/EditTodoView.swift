//
//  EditTodoView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/17/24.
//

import SwiftUI
import PhotosUI

struct EditTodoView: View {
    
    @StateObject var viewModel: EditTodoViewModel
    
    @Binding var isPresented: Bool
    @State var showImagePicker: Bool = false
    
    
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
        
        .sheet(isPresented: $showImagePicker, content: {
            let config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
            PhotoPicker(configuration: config, isPresented: $showImagePicker) { selectedImageData in
                viewModel.action(.selectedImage(imageData: selectedImageData))
            }
        })
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
            if viewModel.output.selectedImageData == nil {
                self.showImagePicker.toggle()
            } else {
                viewModel.action(.removeSelectedImage)
            }
        }, label: {
            Image(viewModel.output.selectedImageData == nil ? "add_image" : "slash_image", bundle: nil)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .tint(.skyblue)
            Text(viewModel.output.selectedImageData == nil ? "사진 추가하기" : "사진 제거하기")
                .tint(Color(uiColor: .label))
                .font(.system(size: 14))
            Spacer()
            Image(uiImage: UIImage(data: viewModel.output.selectedImageData ?? Data()) ?? UIImage())
                .resizable()
                .frame(width: 40, height: 40)
                .padding(.trailing, 25)
        })
        .padding(.leading, 25)
        .padding(.bottom, 15)
    }
    
    private var saveButtonView: some View {
        Button(action: {
            viewModel.action(.editButtonTapped)
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
    EditTodoView(viewModel: EditTodoViewModel(todoItem: Todo(content: "dummy"), onDelete: {
        
    }, onEdit: {_,_  in
        
    }), isPresented: .constant(true))
}
