//
//  PhotoPicker.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/19/24.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    let configuration: PHPickerConfiguration
    @Binding var isPresented: Bool
    
    var onSelectedImage: (Data) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

//MARK: - Coordinator

extension PhotoPicker {
    final class Coordinator: PHPickerViewControllerDelegate {
        private let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            if let result = results.last {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                    guard let self else { return }
                    if let image = object as? UIImage {
                        if let data = image.pngData() {
                            DispatchQueue.main.async {
                                self.parent.onSelectedImage(data)
                            }
                        }
                    }
                }
            }
            self.parent.isPresented = false
        }
    }
}
