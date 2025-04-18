//
//  TrackerStoreFetchController.swift
//  Tracker
//
//  Created by Kirill on 08.04.2025.
//

import CoreData

protocol TrackerStoreFetchControllerProtocol: DataStoreFetchedControllerProtocol where T == TrackerStore {
    func updateFilterWith(selectedDate currentDate: Date, searchString searchTextFilter: String)
}

final class TrackerStoreFetchController: NSObject {
    private weak var dataProviderDelegate: DataProviderForCollectionLayoutDelegate?
    private var dataStore: DataStoreProtocol?
    private var fetchedController:  NSFetchedResultsController<TrackerCoreData>?

    private var insertedSections: IndexSet?
    private var insertedIndexes = [IndexPath]()

    private var deletedSections: IndexSet?
    private var deletedIndexes = [IndexPath]()

    init(dataStore: DataStoreProtocol, dataProviderDelegate: DataProviderForCollectionLayoutDelegate) {
        super.init()
        self.dataStore = dataStore
        self.dataProviderDelegate = dataProviderDelegate
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(TrackerCoreData.category.categoryID), ascending: true),
            NSSortDescriptor(key: #keyPath(TrackerCoreData.name), ascending: true)
        ]
        if let context = dataStore.getContext() {
            let controller = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: context,
                sectionNameKeyPath: #keyPath(TrackerCoreData.category.categoryID),
                cacheName: nil
            )
            self.fetchedController = controller
            self.fetchedController?.delegate = self
        }
    }

    private func createPredicateWith(selectedDate: Date, searchString: String? = nil) -> NSPredicate? {
        guard let currentWeekDay = WeekDay(rawValue: Calendar.current.component(.weekday, from: selectedDate))
        else { return nil }
        let weekDayText = WeekDay.shortWeekdayText[currentWeekDay] ?? ""

        let searchText = searchString?.trimmingCharacters(in: .whitespaces) ?? ""

        if searchText.isEmpty {
            return NSPredicate(
                        format: "%K == %@ OR %K CONTAINS[c] %@",
                        #keyPath(TrackerCoreData.isRegular),
                        NSNumber(booleanLiteral: false),
                        #keyPath(TrackerCoreData.schedule),
                        weekDayText
                   )
        }
        else {
            return NSPredicate(
                        format: "(%K == %@ OR %K CONTAINS[c] %@) AND %K CONTAINS[c] %@",
                        #keyPath(TrackerCoreData.isRegular),
                        NSNumber(booleanLiteral: false),
                        #keyPath(TrackerCoreData.schedule),
                        weekDayText,
                        #keyPath(TrackerCoreData.name),
                        searchText
                   )
        }
    }
}

extension TrackerStoreFetchController: TrackerStoreFetchControllerProtocol {
    var numberOfObjects: Int? {
        fetchedController?.fetchedObjects?.count
    }

    var numberOfSections: Int? {
        fetchedController?.sections?.count
    }

    func numberOfRows(in section: Int) -> Int? {
        fetchedController?.sections?[section].numberOfObjects
    }

    func object(at indexPath: IndexPath) -> TrackerStore? {
        guard let trackerCoreData = fetchedController?.object(at: indexPath)
        else { return nil }

        return TrackerStore(trackerCoreData: trackerCoreData)
    }

    func fetchData() {
        try? fetchedController?.performFetch()
    }

    func updateFilterWith(selectedDate currentDate: Date, searchString searchTextFilter: String) {
        fetchedController?.fetchRequest.predicate = createPredicateWith(
                selectedDate: currentDate,
                searchString: searchTextFilter
        )
        try? fetchedController?.performFetch()
    }
}

extension TrackerStoreFetchController: NSFetchedResultsControllerDelegate {
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
        case .update:
            if let indexPath {
                insertedIndexes.append(indexPath)
                deletedIndexes.append(indexPath)
            }
        case .move:
            if let indexPath {
                deletedIndexes.append(indexPath)
            }
            if let newIndexPath {
                insertedIndexes.append(newIndexPath)
            }
        @unknown default:
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
