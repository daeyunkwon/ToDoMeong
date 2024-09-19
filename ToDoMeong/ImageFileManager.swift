//
//  ImageFileManager.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/19/24.
//

import UIKit

final class ImageFileManager {
    
    static let shared = ImageFileManager()
    private init() { }
    
    func loadImageToDocument(filename: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return nil }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if #available(iOS 16.0, *) {
            if FileManager.default.fileExists(atPath: fileURL.path()) {
                return UIImage(contentsOfFile: fileURL.path())
            } else {
                return nil
            }
        } else {
            // Fallback on earlier versions
            if FileManager.default.fileExists(atPath: fileURL.path) {
                return UIImage(contentsOfFile: fileURL.absoluteString)
            } else {
                return nil
            }
        }
    }
    
    func saveImageToDocument(imageData: Data?, filename: String) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        guard let data = imageData else { return }
        guard let image = UIImage(data: data) else { return }
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            try data.write(to: fileURL)
            
        } catch {
            print("file save error", error)
        }
    }
    
    func removeImageFromDocument(filename: String) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if #available(iOS 16.0, *) {
            if FileManager.default.fileExists(atPath: fileURL.path()) {
                
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path())
                } catch {
                    print("file remove error", error)
                }
            } else {
                print("file no exist")
            }
        } else {
            // Fallback on earlier versions
            if FileManager.default.fileExists(atPath: fileURL.path) {
                
                do {
                    try FileManager.default.removeItem(atPath: fileURL.absoluteString)
                } catch {
                    print("file remove error", error)
                }
            } else {
                print("file no exist")
            }
        }
    }
}
