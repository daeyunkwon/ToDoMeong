//
//  CalendarTodoViewModel.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/22/24.
//

import Foundation
import Combine
import RealmSwift

final class CalendarTodoViewModel: ViewModelType {
    
    private let repository = TodoRepository()
    private var notificationToken: NotificationToken?
    private var todoList: [Todo] = []
    private var selectedDate: Date = Date()
    
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    struct Input {
        let selectedDate = PassthroughSubject<Date, Never>()
        let currentPageDate = PassthroughSubject<Date, Never>()
        let todayButtonTapped = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var selectedDateTodoList: [Todo] = []
        var selectedDate: Date = Date()
        var currentPageDate: Date = Date()
        var moveToday = false
        var isImageUpdate = false
    }
    
    init() {
        observeTodos()
        transform()
    }
    
    func transform() {
        
        input.selectedDate
            .sink { [weak self] selectedDate in
                guard let self else { return }
                self.output.selectedDateTodoList = self.todoList.filter({ todo in
                    let todoDate = Calendar.current.dateComponents([.year, .month, .day], from: todo.createDate)
                    let compare = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
                    
                    if todoDate.year == compare.year && todoDate.month == compare.month && todoDate.day == compare.day {
                        return true
                    } else {
                        return false
                    }
                })
                self.selectedDate = selectedDate
            }
            .store(in: &cancellables)
        
        input.todayButtonTapped
            .sink { [weak self] _ in
                self?.output.moveToday = true
            }
            .store(in: &cancellables)
        
        input.currentPageDate
            .sink { [weak self] date in
                self?.output.currentPageDate = date
            }
            .store(in: &cancellables)
        
        
        
    }
    
    private func observeTodos() {
        let realm = try! Realm()
        let todos = realm.objects(Todo.self)
        
        notificationToken = todos.observe { [weak self] changes in
            guard let self else { return }
            switch changes {
            case .initial:
                // 초기 데이터 로드
                self.todoList = Array(todos)
                self.input.selectedDate.send(self.selectedDate)
            
            case .update(_, _, _, _):
                // 데이터 업데이트
                print("DEBUG: Realm 데이터 변화 감지됨")
                self.todoList = self.repository.fetchAllTodo()
                self.input.selectedDate.send(self.selectedDate)
            
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}

//MARK: - Actions

extension CalendarTodoViewModel {
    enum Action {
        case selectedDate(date: Date)
        case updateCurrentPageDate(date: Date)
        case todayButtonTapped
    }
    
    func action(_ action: Action) {
        switch action {
        case .selectedDate(let date):
            input.selectedDate.send(date)
        case .updateCurrentPageDate(let date):
            input.currentPageDate.send(date)
        case .todayButtonTapped:
            input.todayButtonTapped.send(())
        }
    }
}
