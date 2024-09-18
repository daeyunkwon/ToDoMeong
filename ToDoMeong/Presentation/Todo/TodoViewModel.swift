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
    
    struct Input {
        let viewOnAppear = PassthroughSubject<Void, Never>()
        let delete = PassthroughSubject<Todo, Never>()
    }
    
    struct Output {
        var todoList: [Todo] = []
        var showAddTodoView = false
        var showAddNewCompletionToast = false
        var isAddNewTodo = false
        var showFailedToAddToast = false
        var isFailedAddTodo = false
        var showFailedToDeleteToast = false
    }
    
    init() {
        transform()
    }
    
    func transform() {
        
        input.viewOnAppear.sink { [weak self] _ in
            self?.output.todoList = self?.repository.fetchTodayTodo() ?? []
        }
        .store(in: &cancellables)
        
        input.delete
            .sink { [weak self] todo in
                
                self?.repository.deleteTodo(data: todo) { result in
                    switch result {
                    case .success(_):
                        self?.input.viewOnAppear.send(())
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - Action

extension TodoViewModel {
    enum Action {
        case onAppear
        case delete(target: Todo)
    }
    
    func action(_ action: Action) {
        switch action {
        case .onAppear:
            input.viewOnAppear.send(())
        case .delete(let todo):
            input.delete.send((todo))
        }
    }
}
