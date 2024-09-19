//
//  DetailPhotoView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/19/24.
//

import SwiftUI

struct DetailPhotoView: View {
    
    let todoID: String
    
    var body: some View {
        Text("사진 상세보기")
            .font(.system(size: 15))
            .bold()
            .padding(.top, 20)
        Image(uiImage: ImageFileManager.shared.loadImageToDocument(filename: todoID) ?? UIImage())
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 15)
    }
}

#Preview {
    DetailPhotoView(todoID: "")
}
