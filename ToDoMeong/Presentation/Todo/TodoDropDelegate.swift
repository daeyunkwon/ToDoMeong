//
//  TodoDropDelegate.swift
//  ToDoMeong
//
//  Created by 권대윤 on 5/8/25.
//

import SwiftUI
import RealmSwift

struct TodoDropDelegate: DropDelegate {
    private let viewModel: TodoViewModel
    private let shouldHandleDrop: Bool
    
    /// shouldHandleDrop이 true인 경우에만 drop delete handling이 진행됩니다.
    init(viewModel: TodoViewModel, shouldHandleDrop: Bool) {
        self.viewModel = viewModel
        self.shouldHandleDrop = shouldHandleDrop
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func dropEntered(info: DropInfo) {
        viewModel.action(.draggingCancelTimerStop)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        if shouldHandleDrop {
            let providers = info.itemProviders(for: [.text])
            
            for provider in providers {
                // 비동기적으로 문자열 추출
                provider.loadItem(forTypeIdentifier: "public.text", options: nil) { (data, error) in
                    if let text = data as? Data,
                       let droppedString = String(data: text, encoding: .utf8) {
                        if let objectId = try? ObjectId(string: droppedString) {
                            DispatchQueue.main.async {
                                self.viewModel.action(.dropDelete(targetID: objectId))
                            }
                        } else {
                            // 형식이 유효하지 않음
                            print("DEBUG: 유효하지 않은 ObjectId 문자열")
                        }
                    }
                }
            }
        }
        return true
    }
}
