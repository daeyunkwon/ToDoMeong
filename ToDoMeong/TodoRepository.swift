//
//  TodoRepository.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/16/24.
//

import Foundation
import RealmSwift

final class TodoRepository {
    
    enum RealmError: Error {
        case failedToCreate
        case failedToUpdate
        case failedToDelete
        
        var description: String {
            switch self {
            case .failedToCreate:
                return "Error: Realm에 Todo 데이터 생성 실패되었습니다."
            case .failedToUpdate:
                return "Error: Realm에 Todo 데이터 수정 실패되었습니다."
            case .failedToDelete:
                return "Error: Realm에 Todo 데이터 삭제 실패되었습니다."
            }
        }
    }
    
    private let realm = try! Realm()
    
    
    func fetchTodayTodo() -> [Todo] {
        let result = realm.objects(Todo.self).sorted(byKeyPath: Todo.Key.createDate.rawValue, ascending: true)
        let todayTodoList = result.filter { todo in
            return Calendar.current.isDateInToday(todo.createDate)
        }
        return Array(todayTodoList)
    }
    
    func createTodo(data: Todo, completionHandler: @escaping (Result<Todo, RealmError>) -> Void) {
        do {
            try realm.write {
                realm.create(Todo.self, value: data)
                print("DEBUG: Realm Create Succeed")
                completionHandler(.success(data))
            }
        } catch {
            print(error)
            completionHandler(.failure(.failedToCreate))
        }
    }
    
    func updateTodo(target: Todo, content: String, photo: String?, completion: @escaping (Result<Void, RealmError>) -> Void) {
        
        do {
            try realm.write {
                let value = [
                    Todo.Key.id.rawValue: target.id,
                    Todo.Key.content.rawValue: content,
                    Todo.Key.photo.rawValue: photo as Any
                
                ]
                realm.create(Todo.self, value: value, update: .modified)
                print("DEBUG: Realm Update Succeed")
                completion(.success(()))
            }
            
        } catch {
            print(error)
            completion(.failure(.failedToUpdate))
        }
    }
    
    func deleteTodo(data: Todo, completionHandler: @escaping (Result<Void, RealmError>) -> Void) {
        
        do {
            try realm.write {
                if let object = realm.object(ofType: Todo.self, forPrimaryKey: data.id) {
                    self.realm.delete(object)
                    print("DEBUG: Realm Delete Succeed")
                    completionHandler(.success(()))
                }
            }
        } catch {
            print(error)
            completionHandler(.failure(.failedToDelete))
        }
    }
}
