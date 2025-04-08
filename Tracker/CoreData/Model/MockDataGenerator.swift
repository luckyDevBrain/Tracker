//
//  MockDataGenerator.swift
//  Tracker
//
//  Created by Kirill on 24.03.2025.
//

import CoreData

final class MockDataGenerator {

    private var dataStore: DataStoreProtocol?

    static func setupRecords(with dataProvider: any TrackerDataProviderProtocol) {
        guard let context = dataProvider.dataStore.getContext() else { return }

        let checkRequest = TrackerCoreData.fetchRequest()
        if let result = try? context.fetch(checkRequest),
           result.count > 0 {
            return
        }

        struct TrackerRecord {
            let name: String
            let isRegular: Bool
            let emoji: String
            let color: String
            let schedule: String?
            let isPinned: Bool
        }

         let category1 = TrackerCategoryCoreData(context: context)
        category1.categoryID = UUID()
        category1.name = "Первая категория"

        let tracker = TrackerCoreData(context: context)
        tracker.trackerID = UUID()
        tracker.name = "Завершенная сегодня"
        tracker.isRegular = true
        tracker.emoji = "❤️"
        tracker.color = "ypColorSelection-6"
        tracker.schedule = "Пн,Вт,Ср,Чт,Пт"
        tracker.category = category1
        tracker.categoryID = category1.categoryID
        tracker.isPinned = false

        if let trackerID = tracker.trackerID,
           let currentDate = Date().truncated() {
            dataProvider.switchTracker(withID: trackerID, to: true, for: currentDate)
        } else {
            print("Ошибка наполнения mock-данными: не удалось отметить трекер выполненным")
        }

        // а трекеры добавляем сначала для первой категории -
        // для проверки сортировки по категориям и трекерам
        [
            TrackerRecord(name: "Регулярное событие 1", isRegular: true, emoji: "😻", color: "ypColorSelection-1", schedule: "Пн,Ср,Вс", isPinned: false),
            TrackerRecord(name: "Нерегулярное событие 1", isRegular: false, emoji: "🌺", color: "ypColorSelection-2", schedule: nil, isPinned: true),
            TrackerRecord(name: "Регулярное событие 2", isRegular: true, emoji: "🐶", color: "ypColorSelection-3", schedule: "Вт,Пн,Вс", isPinned: false)
        ].map { raw in
                let tracker = TrackerCoreData(context: context)
                tracker.trackerID = UUID()
                tracker.categoryID = category1.categoryID
                tracker.name = raw.name
                tracker.isRegular = raw.isRegular
                tracker.emoji = raw.emoji
                tracker.color = raw.color
                tracker.schedule = raw.schedule
                tracker.category = category1
                tracker.isPinned = raw.isPinned
                return tracker
        }
        try? context.save()

        // Добавляем категорию 2
        let category2 = TrackerCategoryCoreData(context: context)
        category2.categoryID = UUID()
        category2.name = "Вторая категория, пустая"

        // Добавляем категорию 3
        let category3 = TrackerCategoryCoreData(context: context)
        category3.categoryID = UUID()
        category3.name = "Третья категория"

        // добавляем трекеры для третьей категории
        [
            TrackerRecord(name: "Событие третьей категории 1, регуляр", isRegular: true, emoji: "🐶", color: "ypColorSelection-4", schedule: "Пн", isPinned: true),
            TrackerRecord(name: "нерегулярное событие, категория 3 ", isRegular: false, emoji: "🌺", color: "ypColorSelection-5", schedule: nil, isPinned: false)
        ].map { raw in
                let tracker = TrackerCoreData(context: context)
                tracker.trackerID = UUID()
                tracker.categoryID = category3.categoryID
                tracker.name = raw.name
                tracker.isRegular = raw.isRegular
                tracker.emoji = raw.emoji
                tracker.color = raw.color
                tracker.schedule = raw.schedule
                tracker.category = category3
                tracker.isPinned = raw.isPinned
                return tracker
        }

        try? context.save()
    }

    static func getDefaultCategory(for dataStore: DataStoreProtocol) -> TrackerCategoryStore? {
        guard let context = dataStore.getContext() else { return nil }
        let request = TrackerCategoryCoreData.fetchRequest()
        if let result = try? context.fetch(request),
           let categoryCoreData = result.first {
            return TrackerCategoryStore(categoryCoreData: categoryCoreData)
        } else {
            guard let newCategory = NSEntityDescription.insertNewObject(
                forEntityName: "TrackerCategoryCoreData",
                into: context
            ) as? TrackerCategoryCoreData
            else { return nil }

            newCategory.name = "Дефолтная категория"
            try? context.save()
            return TrackerCategoryStore(categoryCoreData: newCategory)
        }
    }
}
