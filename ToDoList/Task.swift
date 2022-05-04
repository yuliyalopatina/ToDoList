//
//  Task.swift
//  ToDoList
//
//  Created by Yuliya Lopatina on 3.05.22.
//

import Foundation
import RealmSwift

class Task: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title = ""
    @Persisted var completed = false
}
