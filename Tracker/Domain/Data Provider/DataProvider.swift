//
//  DataProvider.swift
//  Tracker
//
//  Created by Kirill on 24.03.2025.
//

import UIKit

// MARK: - Protocols

protocol DataProviderProtocol: AnyObject {
    var numberOfObjects: Int { get }
    var numberOfSections: Int { get }
    var dataStore: DataStoreProtocol { get }
    
    func numberOfRows(in section: Int) -> Int
    func object(at indexPath: IndexPath) -> Tracker?
    func loadData()
    func getDefaultCategory() -> TrackerCategory?
    func save(tracker: Tracker, in category: TrackerCategory)
    func getCategoryNameForTracker(at indexPath: IndexPath) -> String
    func setDateFilter(with date: Date)
    func setSearchTextFilter(with searchText: String)
    func switchTracker(withID trackerID: UUID, to isCompleted: Bool, for date: Date)
    func getCompletedRecordsForTracker(at indexPath: IndexPath) -> Int
    func didUpdate(_ updatedIndexes: UpdatedIndexes)
}

// MARK: - Structs

struct UpdatedIndexes {
    let insertedSections: IndexSet
    let insertedIndexes: [IndexPath]
    let deletedSections: IndexSet
    let deletedIndexes: [IndexPath]
}

// MARK: - Class Definition

final class DataProvider {
    
    // MARK: - Private Properties
    
    private weak var delegate: DataProviderDelegate?
    private var dataStoreFetchedController: DataStoreFetchedControllerProtocol?
    private var currentDate: Date = Date()
    private var searchText: String = ""
    
    // MARK: - Public Properties
    
    var dataStore: DataStoreProtocol
    
    // MARK: - Initializers
    
    init(delegate: DataProviderDelegate) {
        self.delegate = delegate
        self.dataStore = DataStore.shared
        self.dataStoreFetchedController = dataStore.dataStoreFetchedResultController
        self.dataStoreFetchedController?.dataProviderDelegate = self
    }
    
    // MARK: - Private Methods
    
    private func completeTracker(withID trackerID: UUID, for date: Date) {
        let recordStore = TrackerRecordStore(trackerID: trackerID, completedAt: date)
        dataStore.addRecord(recordStore)
    }
    
    private func uncompleteTracker(withID trackerID: UUID, for date: Date) {
        let recordStore = TrackerRecordStore(trackerID: trackerID, completedAt: date)
        dataStore.deleteRecord(recordStore)
    }
}

// MARK: - DataProviderProtocol

extension DataProvider: DataProviderProtocol {
    
    // MARK: - Update Handling
    
    func didUpdate(_ updatedIndexes: UpdatedIndexes) {
        delegate?.didUpdateIndexPath(updatedIndexes)
    }
    
    // MARK: - Tracker Completion
    
    func switchTracker(withID trackerID: UUID, to isCompleted: Bool, for date: Date) {
        if isCompleted {
            completeTracker(withID: trackerID, for: date)
        } else {
            uncompleteTracker(withID: trackerID, for: date)
        }
    }
    
    func getCompletedRecordsForTracker(at indexPath: IndexPath) -> Int {
        guard let tracker = dataStoreFetchedController?.object(at: indexPath) else { return 0 }
        return tracker.completed?.count ?? 0
    }
    
    // MARK: - Filters
    
    func setDateFilter(with date: Date) {
        self.currentDate = date
        dataStoreFetchedController?.updateFilterWith(selectedDate: currentDate, searchString: searchText)
    }
    
    func setSearchTextFilter(with searchText: String) {
        self.searchText = searchText
        dataStoreFetchedController?.updateFilterWith(selectedDate: currentDate, searchString: searchText)
    }
    
    // MARK: - Data Handling
    
    var numberOfObjects: Int {
        dataStoreFetchedController?.numberOfObjects ?? 0
    }
    
    var numberOfSections: Int {
        dataStoreFetchedController?.numberOfSections ?? 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        dataStoreFetchedController?.numberOfRows(in: section) ?? 0
    }
    
    func object(at indexPath: IndexPath) -> Tracker? {
        guard let trackerStore = dataStoreFetchedController?.object(at: indexPath) else { return nil }
        
        let color = UIColor.YpColors(rawValue: trackerStore.color)
        let schedule = WeekDay.getWeekDays(from: trackerStore.schedule ?? "")
        let completedDates = trackerStore.completed
        let isCompleted = completedDates?.first(where: { currentDate.isEqual(to: $0.completedAt) }) != nil
        
        return Tracker(
            trackerID: trackerStore.trackerID,
            name: trackerStore.name,
            isRegular: trackerStore.isRegular,
            emoji: trackerStore.emoji,
            color: color,
            schedule: schedule,
            isCompleted: isCompleted,
            completedCounter: completedDates?.count ?? 0
        )
    }
    
    func loadData() {
        dataStoreFetchedController?.fetchData()
    }
    
    // MARK: - Category Handling
    
    func getDefaultCategory() -> TrackerCategory? {
        guard let categoryStore = MockDataGenerator.getDefaultCategory(for: dataStore) else { return nil }
        return TrackerCategory(id: categoryStore.categoryID, name: categoryStore.name)
    }
    
    func save(tracker: Tracker, in category: TrackerCategory) {
        let trackerStore = TrackerStore(
            trackerID: tracker.trackerID,
            name: tracker.name,
            isRegular: tracker.isRegular,
            emoji: tracker.emoji,
            color: tracker.color?.rawValue ?? "",
            schedule: WeekDay.getDescription(for: tracker.schedule ?? []),
            category: TrackerCategoryStore(categoryID: category.categoryID, name: category.name),
            completed: nil
        )
        
        dataStore.saveTracker(trackerStore)
        dataStoreFetchedController?.fetchData() // Принудительно обновляем данные
    }
    
    func getCategoryNameForTracker(at indexPath: IndexPath) -> String {
        guard let tracker = dataStoreFetchedController?.object(at: indexPath) else { return "" }
        return tracker.category.name
    }
}
