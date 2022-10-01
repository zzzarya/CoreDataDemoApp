//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Антон Заричный on 01.10.2022.
//

import Foundation
import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    let context: NSManagedObjectContext
    
    private init() {
        context = persistentContainer.viewContext
    }
    
    var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
            
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
    
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func fetchData(competion: @escaping([Task]) -> Void ) {
        let fetchRequest = Task.fetchRequest()
        
        do {
          let taskList = try context.fetch(fetchRequest)
            competion(taskList)
        } catch {
            print("Failed to fetch data", error)
        }
    }
    
    func save(_ taskName: String, competion: @escaping(Task) -> Void) {
        let task = Task(context: context)
        task.name = taskName
        competion(task)
        
        saveContext()
    }
    
    func delete(taskList: [Task], indexPath: IndexPath) {
        context.delete(taskList[indexPath.row])
        
        saveContext()
    }
    
    func rename(taskList: [Task], _ taskName: String, indexPath: IndexPath) {
        let cell = taskList[indexPath.row]
        cell.name = taskName
        
        saveContext()
    }
}
