//
//  DataStoreFetchController.swift
//  Tracker
//
//  Created by Kirill on 24.03.2025.
//

import CoreData
import UIKit

// MARK: - Protocol

/// Протокол для управления выборкой данных из хранилища
protocol DataStoreFetchedControllerProtocol {
    var dataProviderDelegate: DataProviderProtocol? { get set }
    var fetchedTrackerController: NSFetchedResultsController<TrackerCoreData>? { get set }
    var numberOfObjects: Int? { get }
    var numberOfSections: Int? { get }
    func numberOfRows(in section: Int) -> Int?
    func object(at: IndexPath) -> TrackerStore?
    func fetchData()
    func updateFilterWith(selectedDate currentDate: Date, searchString searchTextFilter: String)
}

// MARK: - Class Definition

/// Класс для управления выборкой данных трекеров из Core Data
final class DataStoreFetchController: NSObject {
    
    // MARK: - Public Properties
    
    var fetchedTrackerController: NSFetchedResultsController<TrackerCoreData>?
    
    weak var dataProviderDelegate: DataProviderProtocol?
    
    // MARK: - Private Properties
    
    private var insertedSections: IndexSet?
    private var insertedIndexes = [IndexPath]()
    
    private var deletedSections: IndexSet?
    private var deletedIndexes = [IndexPath]()
    
    // MARK: - Initializers
    
    init(context: NSManagedObjectContext) {
        super.init()
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(TrackerCoreData.category), ascending: true),
            NSSortDescriptor(key: #keyPath(TrackerCoreData.name), ascending: true)
        ]
        
        fetchedTrackerController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerCoreData.category),
            cacheName: nil
        )
        
        fetchedTrackerController?.delegate = self
    }
    
    // MARK: - Private Methods
    
    private func createPredicateWith(selectedDate: Date, searchString: String? = nil) -> NSPredicate? {
        guard let startOfDay = selectedDate.truncated(),
              let currentWeekDay = WeekDay(rawValue: Calendar.current.component(.weekday, from: selectedDate))
        else { return nil }
        
        let weekDayText = WeekDay.shortWeekdayText[currentWeekDay] ?? ""
        let searchText = searchString?.trimmingCharacters(in: .whitespaces) ?? ""
        
        let basePredicate = NSPredicate(format:
                                            "(%K == NO AND (%K.@count == 0 OR SUBQUERY(%K, $r, $r.%K == %@).@count > 0)) OR %K CONTAINS[c] %@ OR %K == %@",
                                        #keyPath(TrackerCoreData.isRegular), #keyPath(TrackerCoreData.completed),
                                        #keyPath(TrackerCoreData.completed), #keyPath(TrackerRecordCoreData.completedAt), startOfDay as NSDate,
                                        #keyPath(TrackerCoreData.schedule), weekDayText,
                                        #keyPath(TrackerCoreData.schedule), WeekDay.everydayDescription
        )
        
        if searchText.isEmpty {
            return basePredicate
        } else {
            let namePredicate = NSPredicate(format: "%K CONTAINS[c] %@", #keyPath(TrackerCoreData.name), searchText)
            return NSCompoundPredicate(type: .and, subpredicates: [basePredicate, namePredicate])
        }
    }
}

// MARK: - Extensions

// MARK: - DataStoreFetchedControllerProtocol
extension DataStoreFetchController: DataStoreFetchedControllerProtocol {
    var numberOfObjects: Int? {
        fetchedTrackerController?.fetchedObjects?.count
    }
    
    var numberOfSections: Int? {
        fetchedTrackerController?.sections?.count
    }
    
    func numberOfRows(in section: Int) -> Int? {
        fetchedTrackerController?.sections?[section].numberOfObjects
    }
    
    func object(at indexPath: IndexPath) -> TrackerStore? {
        guard let trackerCoreData = fetchedTrackerController?.object(at: indexPath)
        else { return nil }
        
        return TrackerStore(trackerCoreData: trackerCoreData)
    }
    
    func fetchData() {
        try? fetchedTrackerController?.performFetch()
    }
    
    func updateFilterWith(selectedDate currentDate: Date, searchString searchTextFilter: String) {
        fetchedTrackerController?.fetchRequest.predicate = createPredicateWith(
            selectedDate: currentDate,
            searchString: searchTextFilter
        )
        try? fetchedTrackerController?.performFetch()
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension DataStoreFetchController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedSections = IndexSet()
        insertedIndexes = []
        deletedSections = IndexSet()
        deletedIndexes = []
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dataProviderDelegate?.didUpdate(
            UpdatedIndexes(
                insertedSections: insertedSections ?? IndexSet(),
                insertedIndexes: insertedIndexes,
                deletedSections: deletedSections ?? IndexSet(),
                deletedIndexes: deletedIndexes
            )
        )
        insertedSections = nil
        insertedIndexes = []
        
        deletedSections = nil
        deletedIndexes = []
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                deletedIndexes.append(indexPath)
            }
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes.append(indexPath)
            }
        default:
            break
        }
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType
    ) {
        switch type {
        case .delete:
            deletedSections?.insert(sectionIndex)
        case .insert:
            insertedSections?.insert(sectionIndex)
        default:
            break
        }
    }
}
