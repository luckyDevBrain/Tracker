//
//  TrackerStore.swift
//  Tracker
//
//  Created by Kirill on 24.03.2025.
//

import CoreData

struct TrackerStore {
    let trackerID: UUID
    let name: String
    let isRegular: Bool
    let emoji: String
    let color: String
    let schedule: String?
    let category: TrackerCategoryStore
    let completed: [TrackerRecordStore]?
    let isPinned: Bool

    private enum Constants {
        static let recordForUUIDPredicate = "%K == %@"
    }

    static func deleteRecord(with trackerID: UUID, context: NSManagedObjectContext) {
        guard let trackerCoreData = TrackerCoreData.fetchRecord(
            for: trackerID,
            context: context
        )
        else { return }
        context.delete(trackerCoreData)
        try? context.save()
    }

    static func getRecord(for trackerID: UUID, context: NSManagedObjectContext) -> TrackerStore? {
        guard let trackerCoreData = TrackerCoreData.fetchRecord(for: trackerID, context: context)
        else { return nil }

        return TrackerStore(trackerCoreData: trackerCoreData)
    }

    static func getRecordCount(for date: Date, context: NSManagedObjectContext) -> Int {
        let request = TrackerCoreData.fetchRequest()
        if let query = TrackerQueryBuilder.queryForDate(date) {
            request.predicate = NSPredicate(format: query.queryFormat, argumentArray: query.args)
        }
        let recordCount = try? context.fetch(request).count
        return recordCount ?? 0
    }

    init(
        trackerID: UUID,
        name: String,
        isRegular: Bool,
        emoji: String,
        color: String,
        schedule: String?,
        category: TrackerCategoryStore,
        completed: [TrackerRecordStore]?,
        isPinned: Bool
    ) {
        self.trackerID = trackerID
        self.name = name
        self.isRegular = isRegular
        self.emoji = emoji
        self.color = color
        self.schedule = schedule
        self.category = category
        self.completed = completed
        self.isPinned = isPinned
    }

    init(trackerCoreData: TrackerCoreData) {
        let trackerID = trackerCoreData.trackerID ?? UUID()
        let completedRecords = trackerCoreData.completed as? Set<TrackerRecordCoreData>

        let completedStoreRecords = completedRecords?.compactMap { record -> TrackerRecordStore? in
            guard let completedAt = record.completedAt?.truncated() else { return nil }
            return TrackerRecordStore(trackerID: trackerID, completedAt: completedAt)
        }

        self.init(
            trackerID: trackerID,
            name: trackerCoreData.name ?? "",
            isRegular: trackerCoreData.isRegular,
            emoji: trackerCoreData.emoji ?? "",
            color: trackerCoreData.color ?? "",
            schedule: trackerCoreData.schedule,
            category: TrackerCategoryStore(
                categoryID: trackerCoreData.categoryID ?? UUID(),
                name: trackerCoreData.category?.name ?? ""
            ),
            completed: completedStoreRecords,
            isPinned: trackerCoreData.isPinned
        )
    }

    func addRecord(context: NSManagedObjectContext) {

        let categoryID = category.categoryID
        guard let categoryCoreData = TrackerCategoryCoreData.fetchRecord(for: categoryID, context: context)
        else { return }

        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.trackerID = trackerID
        trackerCoreData.name = name
        trackerCoreData.isRegular = isRegular
        trackerCoreData.emoji = emoji
        trackerCoreData.color = color
        trackerCoreData.schedule = schedule
        trackerCoreData.category = categoryCoreData
        trackerCoreData.categoryID = categoryCoreData.categoryID
        trackerCoreData.completed = nil
        trackerCoreData.isPinned = isPinned
        try? context.save()
    }

    func updateRecord(context: NSManagedObjectContext) {
        let categoryID = category.categoryID
        guard let categoryCoreData = TrackerCategoryCoreData.fetchRecord(for: categoryID, context: context)
        else { return }

        guard let trackerCoreData = TrackerCoreData.fetchRecord(for: trackerID, context: context)
        else { return }

        trackerCoreData.name = name
        trackerCoreData.isRegular = isRegular
        trackerCoreData.emoji = emoji
        trackerCoreData.color = color
        trackerCoreData.schedule = schedule
        trackerCoreData.category = categoryCoreData
        trackerCoreData.categoryID = categoryID
        trackerCoreData.isPinned = isPinned
        try? context.save()
    }
}
