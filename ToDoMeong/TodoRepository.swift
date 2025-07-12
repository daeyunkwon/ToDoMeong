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
        case failedToLoad
        case failedToCreate
        case failedToUpdate
        case failedToDelete
        
        var description: String {
            switch self {
            case .failedToLoad:
                return "Error: Realm에 Todo 데이터 읽기 실패되었습니다."
            case .failedToCreate:
                return "Error: Realm에 Todo 데이터 생성 실패되었습니다."
            case .failedToUpdate:
                return "Error: Realm에 Todo 데이터 수정 실패되었습니다."
            case .failedToDelete:
                return "Error: Realm에 Todo 데이터 삭제 실패되었습니다."
            }
        }
    }
    
    func fetchTodayTodo(completionHandler: @escaping ((Result<[Todo], RealmError>) -> Void)) {
        do {
            let realm = try Realm()
            let result = realm.objects(Todo.self).sorted(byKeyPath: Todo.Key.createDate.rawValue, ascending: true)
            let todayTodoList = result.filter { todo in
                return Calendar.current.isDateInToday(todo.createDate)
            }
            completionHandler(.success(Array(todayTodoList)))
        } catch {
            print(error)
            completionHandler(.failure(.failedToLoad))
        }
    }
    
    func fetchTodo(date: Date) -> Result<[Todo], RealmError> {
        do {
            let realm = try Realm()
            
            let result = realm.objects(Todo.self).sorted(byKeyPath: Todo.Key.createDate.rawValue, ascending: true).filter { todo in
                
                let isSameDay = Calendar.current.isDate(todo.createDate, inSameDayAs: date)
                    
                return isSameDay
            }
            return .success(Array(result))
        } catch {
            print(error)
            return .failure(.failedToLoad)
        }
    }
    
    func fetchTodo(date: Date, completionHandler: @escaping ((Result<[Todo], RealmError>) -> Void)) {
        do {
            let realm = try Realm()
            
            let result = realm.objects(Todo.self).sorted(byKeyPath: Todo.Key.createDate.rawValue, ascending: true).filter { todo in
                
                let isSameDay = Calendar.current.isDate(todo.createDate, inSameDayAs: date)
                    
                return isSameDay
            }
            
            completionHandler(.success(Array(result)))
        } catch {
            print(error)
            completionHandler(.failure(.failedToLoad))
        }
    }
    
    func fetchAllTodo(completionHandler: @escaping (Result<[Todo], RealmError>) -> Void) {
        do {
            let realm = try Realm()
            let result = Array(realm.objects(Todo.self))
            completionHandler(.success(result))
        } catch {
            print(error)
            completionHandler(.failure(.failedToLoad))
        }
    }
    
    func createTodo(data: Todo, completionHandler: @escaping (Result<Todo, RealmError>) -> Void) {
        do {
            let realm = try Realm()
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
            let realm = try Realm()
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
    
    func updateTodoDone(target: Todo, completion: @escaping (Result<Void, RealmError>) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                target.done.toggle()
                let newValue = target.done
                
                let value = [
                    Todo.Key.id.rawValue: target.id,
                    Todo.Key.done.rawValue: newValue,
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
            let realm = try Realm()
            try realm.write {
                if let object = realm.object(ofType: Todo.self, forPrimaryKey: data.id) {
                    realm.delete(object)
                    print("DEBUG: Realm Delete Succeed")
                    completionHandler(.success(()))
                }
            }
        } catch {
            print(error)
            completionHandler(.failure(.failedToDelete))
        }
    }
    
    /// 일치하는 ObjectID의 데이터를 삭제합니다.
    func deleteTodo(todoID: ObjectId, completionHandler: @escaping (Result<Void, RealmError>) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                if let object = realm.object(ofType: Todo.self, forPrimaryKey: todoID) {
                    realm.delete(object)
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
