//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Kirill on 24.03.2025.
//

import CoreData

struct TrackerCategoryStore {
    let categoryID: UUID
    let name: String

    init(categoryID: UUID, name: String) {
        self.categoryID = categoryID
        self.name = name
    }

    init(categoryCoreData: TrackerCategoryCoreData) {
        self.init(
            categoryID: categoryCoreData.categoryID ?? UUID(),
            name: categoryCoreData.name ?? ""
        )
    }

    func addRecord(context: NSManagedObjectContext) {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.categoryID = categoryID
        categoryCoreData.name = name
        try? context.save()
    }

    func save(context: NSManagedObjectContext) {
        if let categoryCoreData = TrackerCategoryCoreData.fetchRecord(
            for: categoryID,
            context: context
        ) {
            categoryCoreData.name = name
            try! context.save()
        }
        else {
            addRecord(context: context)
        }
    }

    func deleteRecord(context: NSManagedObjectContext) {
        guard let categoryCoreData = TrackerCategoryCoreData.fetchRecord(
            for: categoryID,
            context: context
        )
        else { return }
        context.delete(categoryCoreData)
        try? context.save()
    }
}
