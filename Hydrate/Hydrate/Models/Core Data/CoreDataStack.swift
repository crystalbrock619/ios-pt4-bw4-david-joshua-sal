//
//  CoreDataStack.swift
//  Hydrate
//
//  Created by David Wright on 6/23/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    private init() {}
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    private lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Hydrate")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() throws {
        guard mainContext.hasChanges else { return }
        
        var error: Error?
        
        mainContext.performAndWait {
            do {
                try mainContext.save()
            } catch let saveError {
                error = saveError
            }
        }
        
        if let error = error { throw error }
    }
}
