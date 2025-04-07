//
//  AddTodoViewModel.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/17/24.
//

import Foundation
import Combine

final class AddTodoViewModel: ViewModelType {
    
    private let repository = TodoRepository()
    private let selectedDate: Date?
    
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    struct Input {
        var text = PassthroughSubject<String, Never>()
        var addButtonTapped = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var text: String = ""
        var addTodoResult = PassthroughSubject<Result<Todo, TodoRepository.RealmError>, Never>()
    }
    
    init(selectedDate: Date?) {
        self.selectedDate = selectedDate
        transform()
    }
    
    func transform() {
        input.text
            .sink { [weak self] text in
                self?.output.text = text
            }
            .store(in: &cancellables)
        
        input.addButtonTapped
            .sink { [weak self] _ in
                guard let self else { return }
                
                let newTodo = Todo(content: self.output.text)
                
                // 캘린더에서 날짜 지정하여 할일 추가한 경우
                if let selectedDate = self.selectedDate, !Calendar.current.isDateInToday(selectedDate) {
                    repository.fetchTodo(date: selectedDate) { result in
                        switch result {
                        case .success(let selectedDateTodoList):
                            
                            if selectedDateTodoList.isEmpty {
                                newTodo.createDate = selectedDate
                            } else {
                                guard var lastDate = selectedDateTodoList.last?.createDate.timeIntervalSince1970 else { return }
                                lastDate += 0.01
                                let dateForSave = Date(timeIntervalSince1970: lastDate)
                                newTodo.createDate = dateForSave
                            }
                            
                            self.repository.createTodo(data: newTodo) { result in
                                switch result {
                                case .success(let data):
                                    self.output.addTodoResult.send(.success(data))
                                
                                case .failure(let error):
                                    print(error)
                                    self.output.addTodoResult.send(.failure(.failedToCreate))
                                }
                            }
                        
                        case .failure(let error):
                            print(error.description)
                            self.output.addTodoResult.send(.failure(.failedToLoad))
                        }
                    }
                } else {
                    // 할 일 탭에서 할 일 추가한 경우
                    self.repository.createTodo(data: newTodo) { result in
                        switch result {
                        case .success(let data):
                            self.output.addTodoResult.send(.success(data))
                        
                        case .failure(let error):
                            print(error)
                            self.output.addTodoResult.send(.failure(.failedToCreate))
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - Action

extension AddTodoViewModel {
    enum Action {
        case inputText(String)
        case addButtonTapped
    }
    
    func action(_ action: Action) {
        switch action {
        case .inputText(let text):
            self.input.text.send(text)
        
        case .addButtonTapped:
            self.input.addButtonTapped.send(())
        }
    }
}
