//
//  RealmManager.swift
//  ToDoList
//
//  Created by Yuliya Lopatina on 3.05.22.
//

import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    private(set) var localRealm: Realm?
    @Published private(set) var tasks: [Task] = []
    
    init() {
        openRealm()
        getTasks()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1) { migration, oldSchemaVersion in
                if oldSchemaVersion > 1 {
                    //update scheme
                }
            }
            
            Realm.Configuration.defaultConfiguration = config
             
            localRealm = try Realm()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addTask(taskTitle: String) {
        if let localRealm = localRealm {
            do {
                try localRealm.write{
                    let newTask = Task(value: ["title": taskTitle, "completed": false])
                    localRealm.add(newTask)
                    getTasks()
                }
            } catch {
                print(error)
            }
        }
    }
    
    func getTasks() {
        if let localRealm = localRealm {
            let allTasks = localRealm.objects(Task.self).sorted(byKeyPath: "completed")
            tasks = []
            allTasks.forEach { task in
                tasks.append(task)
            }
        }
    }
    
    func updateTask(id: ObjectId, completed: Bool) {
        if let localRealm = localRealm {
            do {
                let tasksToUpdate = localRealm.objects(Task.self).filter(NSPredicate(format: "id == %@", id))
                guard !tasksToUpdate.isEmpty else { return }
                
                try localRealm.write({
                    tasksToUpdate[0].completed = completed
                    getTasks()
                })
            } catch {
                print(error)
            }
        }
    }
    
    func deleteTask(id: ObjectId) {
        if let localRealm = localRealm {
            do {
                let tasksToDelete = localRealm.objects(Task.self).filter(NSPredicate(format: "id == %@", id))
                guard !tasksToDelete.isEmpty else { return }
                
                try localRealm.write({
                    localRealm.delete(tasksToDelete )
                    getTasks()
                })
            } catch {
                print(error)
            }
        }
    }
}
