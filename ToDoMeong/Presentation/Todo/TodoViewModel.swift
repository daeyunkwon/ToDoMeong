//
//  TodoViewModel.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/16/24.
//

import Foundation
import Combine
import RealmSwift

final class TodoViewModel: ViewModelType {
    
    private let repository = TodoRepository()
    
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    enum AddResultFeedbackType {
        case succeed
        case failed
    }
    
    struct Input {
        let fetchTodo = PassthroughSubject<Void, Never>()
        let delete = PassthroughSubject<Todo, Never>()
        let edit = PassthroughSubject<(Todo, String, Data?), Never>()
        let done = PassthroughSubject<Todo, Never>()
        let addButtonTapped = PassthroughSubject<Void, Never>()
        let showAddCompletionFeedback = PassthroughSubject<AddResultFeedbackType, Never>()
    }
    
    struct Output {
        var todoList: [Todo] = []
        var showAddTodoView = false
        var showAddNewCompletionToast = false
        var showFailedToAddToast = false
        var showFailedToDeleteToast = false
        var showUpdateSucceedToast = false
        var showUpdateFailedToast = false
    }
    
    init() {
        transform()
    }
    
    func transform() {
        
        input.fetchTodo.sink { [weak self] _ in
            self?.output.todoList = self?.repository.fetchTodayTodo() ?? []
        }
        .store(in: &cancellables)
        
        input.delete
            .sink { [weak self] todo in
                
                self?.repository.deleteTodo(data: todo) { result in
                    switch result {
                    case .success(_):
                        self?.input.fetchTodo.send(())
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            .store(in: &cancellables)
        
        input.edit
            .sink { [weak self] target, content, imageData in
                guard let self else { return }
                
                if imageData == nil {
                    //기존 이미지 제거하기
                    if target.photo != nil {
                        ImageFileManager.shared.removeImageFromDocument(filename: target.id.stringValue)
                    }
                    
                    repository.updateTodo(target: target, content: content, photo: nil) { result in
                        switch result {
                        case .success(_):
                            self.input.fetchTodo.send(())
                            self.output.showUpdateSucceedToast = true
                        case .failure(let error):
                            print(error)
                            self.output.showUpdateFailedToast = true
                        }
                    }
                } else {
                    //새로운 이미지로 저장하기
                    ImageFileManager.shared.saveImageToDocument(imageData: imageData, filename: target.id.stringValue)
                    
                    repository.updateTodo(target: target, content: content, photo: target.id.stringValue) { result in
                        switch result {
                        case .success(_):
                            self.input.fetchTodo.send(())
                            self.output.showUpdateSucceedToast = true
                        case .failure(let error):
                            print(error)
                            self.output.showUpdateFailedToast = true
                        }
                    }
                }
            }
            .store(in: &cancellables)
        
        input.done
            .sink { [weak self] targetTodo in
                guard let self else { return }
                
                repository.updateTodoDone(target: targetTodo) { result in
                    switch result {
                    case .success(_):
                        self.input.fetchTodo.send(())
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            .store(in: &cancellables)
        
        input.addButtonTapped
            .sink { [weak self] _ in
                self?.output.showAddTodoView = true
            }
            .store(in: &cancellables)
        
        input.showAddCompletionFeedback
            .sink { [weak self] result in
                switch result {
                case .succeed:
                    self?.output.showAddNewCompletionToast = true
                
                case .failed:
                    self?.output.showFailedToAddToast = true
                }
                HapticManager.shared.impact(style: .light)
            }
            .store(in: &cancellables)
    }
}

//MARK: - Action

extension TodoViewModel {
    enum Action {
        case onAppear
        case delete(target: Todo)
        case edit(target: Todo, content: String, imageData: Data?)
        case done(target: Todo)
        case addButtonTapped
        case showAddCompletionFeedback(type: AddResultFeedbackType)
    }
    
    func action(_ action: Action) {
        switch action {
        case .onAppear:
            input.fetchTodo.send(())
        
        case .delete(let todo):
            input.delete.send((todo))
        
        case .edit(let target, let content, let imageData):
            input.edit.send((target, content, imageData))
        
        case .done(let target):
            input.done.send((target))
            
        case .addButtonTapped:
            input.addButtonTapped.send(())
            
        case .showAddCompletionFeedback(let type):
            switch type {
            case .succeed:
                input.showAddCompletionFeedback.send(.succeed)
            case .failed:
                input.showAddCompletionFeedback.send(.failed)
            }
        }
    }
}
