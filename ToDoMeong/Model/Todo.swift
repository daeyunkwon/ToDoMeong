//
//  Todo.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/16/24.
//

import Foundation
import RealmSwift

final class Todo: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var content: String
    @Persisted var done: Bool
    @Persisted var createDate: Date
    @Persisted var photo: String?
    
    convenience init(content: String) {
        self.init()
        self.content = content
        self.createDate = Date()
        self.done = false
    }
    
    enum Key: String {
        case id
        case content
        case done
        case createDate
        case photo
    }
}
