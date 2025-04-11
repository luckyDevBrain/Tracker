//
//  DataStore.swift
//  Tracker
//
//  Created by Kirill on 24.03.2025.
//

import CoreData

protocol DataStoreProtocol: AnyObject {
    func getContext() -> NSManagedObjectContext?
}

final class DataStore: DataStoreProtocol {

    static var shared: DataStore = DataStore()
    private var persistentContainer: NSPersistentContainer

    private enum Constants {
        static let persistentContainerName = "HabitTracker"
    }

    init() {
        self.persistentContainer = NSPersistentContainer(name: Constants.persistentContainerName)
        self.persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error {
                assertionFailure("Ошибка инициализации хранилища данных: \(error)")
            }
        })
    }

    func getContext() -> NSManagedObjectContext?  {
        return persistentContainer.viewContext
    }
}
