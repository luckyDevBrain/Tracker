//
//  DataProvider.swift
//  Tracker
//
//  Created by Kirill on 24.03.2025.
//

import UIKit

protocol CategoryDataProviderProtocol: AnyObject, DataProviderForDataSource, DataProviderForTableViewDelegate {
    var dataStore: DataStoreProtocol { get }
    var numberOfObjects: Int { get }
    func loadData()
    func getDefaultCategory() -> TrackerCategory?
    func save(category: TrackerCategory)
    func deleteCategory(at indexPath: IndexPath)
}

final class CategoryDataProvider {
    var dataStore: DataStoreProtocol
    private weak var delegate: CategoryDataProviderDelegate?
    private var fetchedController: (any DataStoreFetchedControllerProtocol)?

    init(delegate: CategoryDataProviderDelegate) {
        self.dataStore = DataStore.shared
        self.delegate = delegate
        self.fetchedController = CategoryStoreFetchController(
            dataStore: dataStore,
            dataProviderDelegate: self
        )
    }
}

extension CategoryDataProvider: DataProviderForDataSource {
    typealias T = TrackerCategory

    var numberOfSections: Int {
        fetchedController?.numberOfSections ?? 1
    }

    func numberOfRows(in section: Int) -> Int {
        fetchedController?.numberOfRows(in: section) ?? 0
    }

    func object(at indexPath: IndexPath) -> T? {
        guard let categoryStore = fetchedController?.object(at: indexPath) as? TrackerCategoryStore
        else { return nil }

        let category = T(id: categoryStore.categoryID, name: categoryStore.name)
        return category
    }
}

extension CategoryDataProvider: DataProviderForTableViewDelegate {
    func didUpdate(_ updatedIndexes: UpdatedIndexes) {
        delegate?.didUpdateIndexPath(updatedIndexes)
    }
}

extension CategoryDataProvider: CategoryDataProviderProtocol {
    var numberOfObjects: Int {
        fetchedController?.numberOfObjects ?? 0
    }

    func loadData() {
        fetchedController?.fetchData()
    }

    func getDefaultCategory() -> TrackerCategory? {
        guard let categoryStore = MockDataGenerator.getDefaultCategory(for: dataStore)
        else { return nil }

        return TrackerCategory(id: categoryStore.categoryID, name: categoryStore.name)
    }

    func save(category: TrackerCategory) {

        guard let context = dataStore.getContext() else { return }

        let categoryStore = TrackerCategoryStore(categoryID: category.categoryID, name: category.name)
        categoryStore.save(context: context)
    }

    func deleteCategory(at indexPath: IndexPath) {
        guard let category = object(at: indexPath),
              let context = dataStore.getContext()
        else { return }

        let categoryStore = TrackerCategoryStore(categoryID: category.categoryID, name: category.name)
        categoryStore.deleteRecord(context: context)
    }
}
