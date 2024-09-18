//
//  EditTodoViewModel.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/17/24.
//

import SwiftUI
import Combine
import RealmSwift

final class EditTodoViewModel: ViewModelType {
    
    private var todoItem: Todo
    private var isPresented: Binding<Bool>
    private var onDelete: () -> Void
    
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    struct Input {
        let text = PassthroughSubject<String, Never>()
        let dismissEditView = PassthroughSubject<Void, Never>()
        let deleteButtonTapped = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var text = ""
        lazy var todoItem: Todo = todoItem
    }
    
    init(
        todoItem: Todo, isPresented: Binding<Bool>, onDelete: @escaping () -> Void) {
        self.todoItem = todoItem
        self.isPresented = isPresented
        self.onDelete = onDelete
        output.text = todoItem.content
        
        transform()
    }
    
    func transform() {
        input.text
            .sink { [weak self] text in
                guard let self else { return }
                self.output.text = text
            }
            .store(in: &cancellables)
        
        input.dismissEditView
            .sink { [weak self] _ in
                self?.isPresented.wrappedValue = false
            }
            .store(in: &cancellables)
        
        input.deleteButtonTapped
            .sink { [weak self] _ in
                self?.onDelete()
            }
            .store(in: &cancellables)
    }
}

//MARK: - Action

extension EditTodoViewModel {
    enum Action {
        case deleteButtonTapped
    }
    
    func action(_ action: Action) {
        switch action {
        case .deleteButtonTapped:
            input.deleteButtonTapped.send(())
        }
    }
}
