//
//  CoreDataManager.swift
//  CompanyData
//
//  Created by Derick on 11/08/2018.
//  Copyright © 2018 IndiemaxCorp. All rights reserved.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager() // Will live forever as long as the application is alive, and its properties too.
    
    let persistenceContainer: NSPersistentContainer = {
        // Initialisation of core data stack
        let container = NSPersistentContainer(name: "CompanyDataModels")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed. Error: \(err)")
            }
        }
        return container
    }()
    
}
