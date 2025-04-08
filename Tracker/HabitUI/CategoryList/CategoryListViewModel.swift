//
//  CategoryListViewModel.swift
//  Tracker
//
//  Created by Kirill on 08.04.2025.
//

import Foundation
import Combine

struct CategoryListViewModelBindings {
    let isPlaceHolderHidden: (Bool?) -> Void
    let selectedRow: (IndexPath?) -> Void
    let editingCategory: (TrackerCategory?) -> Void
}

protocol CategoryListViewModelProtocol: AnyObject {
    var dataProvider: any CategoryDataProviderProtocol { get }
    var categoriesCount: Int { get }
    func viewDidLoad()
    func setBindings(_ bindings: CategoryListViewModelBindings)
    func didSelectRow(at indexPath: IndexPath, isInitialSelection: Bool)
    func didDeselectRow(at indexPath: IndexPath)
    func updateViewModels(deleteAt deletedIndexes: [IndexPath], insertAt insertedIndexes: [IndexPath])
    func cellViewModel(forCellAt indexPath: IndexPath) -> CategoryCellViewModelProtocol
    func configCell(at indexPath: IndexPath)
    func editCategoryDidTap(at indexPath: IndexPath)
    func categoryEditingDidEnd()
    func deleteCategoryDidTap(at indexPath: IndexPath)
    func updateEditedCategory(_ category: TrackerCategory)
}

final class CategoryListViewModel: CategoryListViewModelProtocol {

    var dataProvider: any CategoryDataProviderProtocol
    var categoriesCount: Int {
        dataProvider.numberOfObjects
    }

    @Published private var isPlaceHolderHidden: Bool?
    @Published private var selectedRow: IndexPath?
    @Published private var editingCategory: TrackerCategory?

    private var cancellables = Set<AnyCancellable>()

    private var selectionDelegate: CategorySelectionDelegate
    private var selectedCategory: TrackerCategory?
    private var cellViewModels: [CategoryCellViewModelProtocol] = []

    init(
        dataProvider: any CategoryDataProviderProtocol,
        selectedCategory: TrackerCategory?,
        selectionDelegate: CategorySelectionDelegate
    ) {
        self.dataProvider = dataProvider
        self.selectedCategory = selectedCategory
        self.selectionDelegate = selectionDelegate
    }

    func viewDidLoad() {
        dataProvider.loadData()
        isPlaceHolderHidden = categoriesCount > 0
    }

    func setBindings(_ bindings: CategoryListViewModelBindings) {
        $isPlaceHolderHidden
            .sink(receiveValue: bindings.isPlaceHolderHidden)
            .store(in: &cancellables)

        $selectedRow
            .sink(receiveValue: bindings.selectedRow)
            .store(in: &cancellables)

        $editingCategory
            .sink(receiveValue: bindings.editingCategory)
            .store(in: &cancellables)
    }

    func configCell(at indexPath: IndexPath) {
        guard let category = dataProvider.object(at: indexPath) as? TrackerCategory else { return }

        let isSelected = selectedCategory?.categoryID == category.categoryID
        cellViewModels[indexPath.item].setupModelWith(
            categoryName: category.name,
            isSelected: isSelected
        )

        if isSelected {
            selectedRow = indexPath
        }
    }

    func didSelectRow(at indexPath: IndexPath, isInitialSelection: Bool) {
        selectedRow = indexPath
        cellViewModels[indexPath.item].didSelectRow()
        if !isInitialSelection,
           let category = dataProvider.object(at: indexPath) as? TrackerCategory {
            selectionDelegate.updateSelected(category)
        }
    }

    func didDeselectRow(at indexPath: IndexPath) {
        cellViewModels[indexPath.item].didDeselectRow()
        selectedRow = nil
        selectedCategory = nil
    }

    func updateViewModels(deleteAt deletedIndexes: [IndexPath], insertAt insertedIndexes: [IndexPath]) {
        deletedIndexes.sorted(by: { $0.item > $1.item }).forEach {
            removeCellViewModel(at: $0)
        }
    }

    func cellViewModel(forCellAt indexPath: IndexPath) -> CategoryCellViewModelProtocol {
        return addCellViewModel(at: indexPath)
    }

    func editCategoryDidTap(at indexPath: IndexPath) {
        guard let category = dataProvider.object(at: indexPath) as? TrackerCategory else { return }
        editingCategory = category
    }

    func categoryEditingDidEnd() {
        editingCategory = nil
    }

    func updateEditedCategory(_ category: TrackerCategory) {
        dataProvider.save(category: category)
        if selectedCategory?.categoryID == category.categoryID {
            selectionDelegate.updateSelected(category)
        }
    }

    func deleteCategoryDidTap(at indexPath: IndexPath) {
        didDeselectRow(at: indexPath)
        selectionDelegate.updateSelected(nil)
        dataProvider.deleteCategory(at: indexPath)
    }

    private func addCellViewModel(at indexPath: IndexPath) -> CategoryCellViewModelProtocol {
        let newModel = CategoryCellViewModel()
        cellViewModels.insert(newModel, at: indexPath.item)
        return newModel
    }

    private func removeCellViewModel(at indexPath: IndexPath) {
        cellViewModels.remove(at: indexPath.item)
    }
}
