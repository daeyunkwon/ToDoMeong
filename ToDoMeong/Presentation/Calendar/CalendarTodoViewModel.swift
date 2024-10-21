//
//  CalendarTodoViewModel.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/22/24.
//

import Foundation
import Combine
import WidgetKit
import RealmSwift

final class CalendarTodoViewModel: ViewModelType {
    
    private let userDefaults = UserDefaults(suiteName: "group.com.daeyunkwon.ToDoMeong")
    private let repository = TodoRepository()
    private var notificationToken: NotificationToken?
    private var todoList: [Todo] = []
    private var selectedDate: Date = Date()
    
    enum ErrorToastType {
        case failedToAdd
        case failedToEdit
        case failedToDelete
        case failedToLoad
    }
    
    enum CompletionToastType {
        case addNewTodo
        case editTodo
    }
    
    
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    struct Input {
        let selectedDate = PassthroughSubject<Date, Never>()
        let currentPageDate = PassthroughSubject<Date, Never>()
        let todayButtonTapped = PassthroughSubject<Void, Never>()
        let onDone = PassthroughSubject<Todo, Never>()
        let onDelete = PassthroughSubject<Todo, Never>()
        let onEdit = PassthroughSubject<(Todo, String, Data?), Never>()
        let moveToPreviousMonthButtonTapped = PassthroughSubject<Void, Never>()
        let moveToNextMonthButtonTapped = PassthroughSubject<Void, Never>()
        let addTodoButtonTapped = PassthroughSubject<Void, Never>()
        let showSucceedToast = PassthroughSubject<CompletionToastType, Never>()
        let showFailedToast = PassthroughSubject<ErrorToastType, Never>()
    }
    
    struct Output {
        var selectedDateTodoList: [Todo] = []
        var selectedDate: Date = Date()
        var currentPageDate: Date = Date()
        var moveToday = false
        var isImageUpdate = false
        var showFailedToast: (Bool, ErrorToastType) = (false, ErrorToastType.failedToAdd)
        var showSucceedToast: (Bool, CompletionToastType) = (false, CompletionToastType.addNewTodo)
        var moveToPreviousMonth = false
        var moveToNextMonth = false
        var showAddTodoView = false
        var isAddNewTodo = false
        var isFailedAddTodo = false
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
                output.selectedDate = self.selectedDate
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
        
        input.onDone
            .sink { [weak self] todo in
                guard let self else { return }
                repository.updateTodoDone(target: todo) { result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(let error):
                        print(error)
                        self.input.showFailedToast.send(.failedToEdit)
                    }
                }
            }
            .store(in: &cancellables)
        
        input.onDelete
            .sink { [weak self] todo in
                guard let self else { return }
                repository.deleteTodo(data: todo) { result in
                    switch result {
                    case .success():
                        break
                    case .failure(let error):
                        print(error)
                        self.input.showFailedToast.send(.failedToDelete)
                    }
                }
            }
            .store(in: &cancellables)
        
        input.onEdit
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
                            self.input.showSucceedToast.send(.editTodo)
                        case .failure(let error):
                            print(error)
                            self.input.showFailedToast.send(.failedToEdit)
                        }
                    }
                } else {
                    //새로운 이미지로 저장하기
                    ImageFileManager.shared.saveImageToDocument(imageData: imageData, filename: target.id.stringValue)
                    
                    repository.updateTodo(target: target, content: content, photo: target.id.stringValue) { result in
                        switch result {
                        case .success(_):
                            self.input.showSucceedToast.send(.editTodo)
                        case .failure(let error):
                            print(error)
                            self.input.showFailedToast.send(.failedToEdit)
                        }
                    }
                }
            }
            .store(in: &cancellables)
        
        input.moveToPreviousMonthButtonTapped
            .sink { [weak self] _ in
                self?.output.moveToPreviousMonth = true
            }
            .store(in: &cancellables)
        
        input.moveToNextMonthButtonTapped
            .sink { [weak self] _ in
                self?.output.moveToNextMonth = true
            }
            .store(in: &cancellables)
        
        input.addTodoButtonTapped
            .sink { [weak self] _ in
                self?.output.showAddTodoView = true
            }
            .store(in: &cancellables)
        
        input.showSucceedToast
            .sink { [weak self] type in
                self?.output.showSucceedToast = (true, type)
            }
            .store(in: &cancellables)
        
        input.showFailedToast
            .sink { [weak self] type in
                self?.output.showFailedToast = (true, type)
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
                self.todoList = Array(todos)
                self.input.selectedDate.send(self.selectedDate)
                self.output.isImageUpdate = true
                
                //위젯 업데이트
                let todayCount = repository.fetchTodayTodo().count
                self.userDefaults?.set(todayCount, forKey: "count")
                WidgetCenter.shared.reloadTimelines(ofKind: "ToDoMeongBasicWidget")
            
            case .error(let error):
                print(error.localizedDescription)
                self.input.showFailedToast.send(.failedToLoad)
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
        case onDone(target: Todo)
        case onDelete(target: Todo)
        case onEdit(target: Todo, content: String, imageData: Data?)
        case movePreviousMonth
        case moveNextMonth
        case addTodoButtonTapped
        case showSucceedToast(CompletionToastType)
        case showFailedToast(ErrorToastType)
    }
    
    func action(_ action: Action) {
        switch action {
        case .selectedDate(let date):
            input.selectedDate.send(date)
        case .updateCurrentPageDate(let date):
            input.currentPageDate.send(date)
        case .todayButtonTapped:
            input.todayButtonTapped.send(())
        case .onDone(let target):
            input.onDone.send(target)
        case .onDelete(let target):
            input.onDelete.send(target)
        case .onEdit(let target, let content, let imageData):
            input.onEdit.send((target, content, imageData))
        case .movePreviousMonth:
            input.moveToPreviousMonthButtonTapped.send(())
        case .moveNextMonth:
            input.moveToNextMonthButtonTapped.send(())
        case .addTodoButtonTapped:
            input.addTodoButtonTapped.send(())
        case .showSucceedToast(let type):
            input.showSucceedToast.send(type)
        case .showFailedToast(let type):
            input.showFailedToast.send(type)
        }
    }
}
