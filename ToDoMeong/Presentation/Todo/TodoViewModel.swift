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
    //MARK: - State
    
    private let repository = TodoRepository()
    
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    private var draggingCancelTimer: AnyCancellable?
    var count: Int = -1
    
    enum AddResultFeedbackType {
        case succeed
        case failed
    }
    
    struct Input {
        let fetchTodo = PassthroughSubject<Void, Never>()
        let delete = PassthroughSubject<Todo, Never>()
        let dropDelete = PassthroughSubject<ObjectId, Never>()
        let edit = PassthroughSubject<(Todo, String, Data?), Never>()
        let done = PassthroughSubject<Todo, Never>()
        let addButtonTapped = PassthroughSubject<Void, Never>()
        let showAddCompletionFeedback = PassthroughSubject<AddResultFeedbackType, Never>()
        let onDragging = PassthroughSubject<Void, Never>()
        let draggingCancelTimerStop = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var today: Date = Date()
        var todoList: [Todo] = []
        var showAddTodoView = false
        var showAddNewCompletionToast = false
        var showFailedToAddToast = false
        var showFailedToDeleteToast = false
        var showUpdateSucceedToast = false
        var showUpdateFailedToast = false
        var bounce = false
        var isDragging = false
    }
    
    init() {
        transform()
    }
    
    //MARK: - Bind
    
    func transform() {
        
        input.fetchTodo.sink { [weak self] _ in
            self?.repository.fetchTodayTodo { result in
                switch result {
                case .success(let todoList):
                    self?.output.todoList = todoList
                    self?.count = todoList.count
                    self?.output.today = Date()
                
                case .failure(let error):
                    print(error.description)
                }
            }
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
        
        input.dropDelete
            .sink { [weak self] todoID in
                self?.repository.deleteTodo(todoID: todoID) { result in
                    switch result {
                    case .success(_):
                        self?.repository.fetchTodayTodo { result in
                            switch result {
                            case .success(let todoList):
                                self?.output.todoList = todoList
                                HapticManager.shared.impact(style: .light)
                                self?.output.bounce = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    self?.output.bounce = false
                                }
                            
                            case .failure(let error):
                                print(error.description)
                            }
                        }
                        
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
                    self?.count = self?.output.todoList.count ?? -1
                
                case .failed:
                    self?.output.showFailedToAddToast = true
                }
                HapticManager.shared.impact(style: .light)
            }
            .store(in: &cancellables)
        
        input.onDragging
            .sink { [weak self] _ in
                self?.output.isDragging = true
                
                // 이전 타이머 취소 (중복 방지)
                self?.draggingCancelTimer?.cancel()
                
                // 새로운 타이머 시작
                self?.draggingCancelTimer = Just(())
                    .delay(for: .seconds(0.25), scheduler: RunLoop.main)
                    .sink { _ in
                        self?.output.isDragging = false
                        self?.count = self?.output.todoList.count ?? -1
                    }
            }
            .store(in: &cancellables)
        
        input.draggingCancelTimerStop
            .sink { [weak self] _ in
                self?.draggingCancelTimer?.cancel()
                self?.output.isDragging = true
            }
            .store(in: &cancellables)
    }
}

//MARK: - Action

extension TodoViewModel {
    enum Action {
        case onAppear
        case delete(target: Todo)
        case dropDelete(targetID: ObjectId)
        case edit(target: Todo, content: String, imageData: Data?)
        case done(target: Todo)
        case addButtonTapped
        case showAddCompletionFeedback(type: AddResultFeedbackType)
        case onDragging
        case draggingCancelTimerStop
    }
    
    func action(_ action: Action) {
        switch action {
        case .onAppear:
            input.fetchTodo.send(())
        
        case .delete(let todo):
            input.delete.send((todo))
            
        case .dropDelete(let targetID):
            input.dropDelete.send(targetID)
        
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
            
        case .onDragging:
            input.onDragging.send(())
            
        case .draggingCancelTimerStop:
            input.draggingCancelTimerStop.send(())
        }
    }
}
