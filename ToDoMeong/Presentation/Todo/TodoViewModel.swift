//
//  TodoViewModel.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/16/24.
//

import Foundation
import Combine

final class TodoViewModel: ViewModelType {
    
    private let repository = TodoRepository()
    
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    struct Input {
        var viewOnAppear = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var todoList: [Todo] = []
        var showAddTodoView = false
        var showAddNewCompletionToast = false
        var isAddNewTodo = false
        var showFailedToAddToast = false
        var isFailedAddTodo = false
    }
    
    init() {
        transform()
    }
    
    func transform() {
        
        input.viewOnAppear.sink { [weak self] _ in
            self?.fetchTodos()
        }
        .store(in: &cancellables)
    }
    
    private func fetchTodos() {
        output.todoList = repository.fetchTodayTodo()
    }
}

//MARK: - Action

extension TodoViewModel {
    enum Action {
        case onAppear
    }
    
    func action(_ action: Action) {
        input.viewOnAppear.send(())
    }
}
