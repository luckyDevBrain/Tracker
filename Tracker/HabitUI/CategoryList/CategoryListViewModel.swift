//
//  CategoryListViewModel.swift
//  Tracker
//
//  Created by Kirill on 08.04.2025.
//

import Foundation

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

    private var isPlaceHolderHidden = ObservableBox<Bool?>(false)
    private var selectedRow = ObservableBox<IndexPath?>(nil)
    private var editingCategory = ObservableBox<TrackerCategory?>(nil)

    private var selectionDelegate: CategorySelectionDelegate
    private var selectedCategory: TrackerCategory?
    private var cellViewModels: [CategoryCellViewModelProtocol]

    init(
        dataProvider: any CategoryDataProviderProtocol,
        selectedCategory: TrackerCategory?,
        selectionDelegate: CategorySelectionDelegate
    ) {
        self.dataProvider = dataProvider
        self.selectedCategory = selectedCategory
        self.cellViewModels = []
        self.selectionDelegate = selectionDelegate
    }

    func viewDidLoad() {
        dataProvider.loadData()
        isPlaceHolderHidden.value = categoriesCount > 0
    }

    func configCell(at indexPath: IndexPath) {
        guard let category = dataProvider.object(at: indexPath) as? TrackerCategory else { return }

        let isSelected = selectedCategory?.categoryID == category.categoryID
        cellViewModels[indexPath.item].setupModelWith(
            categoryName: category.name,
            isSelected: isSelected
        )

        if isSelected {
            selectedRow.value = indexPath
        }
    }

    func setBindings(_ bindings: CategoryListViewModelBindings) {
        isPlaceHolderHidden.bind { bindings.isPlaceHolderHidden($0) }
        selectedRow.bind { bindings.selectedRow($0) }
        editingCategory.bind { bindings.editingCategory($0) }
    }

    func didSelectRow(at indexPath: IndexPath, isInitialSelection: Bool) {
        selectedRow.value = indexPath
        cellViewModels[indexPath.item].didSelectRow()
        if !isInitialSelection {
            guard let category = dataProvider.object(at: indexPath) as? TrackerCategory else { return }
            selectionDelegate.updateSelected(category)
        }
    }

    func didDeselectRow(at indexPath: IndexPath) {
        cellViewModels[indexPath.item].didDeselectRow()
        selectedRow.value = nil
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
        editingCategory.value = category
    }

    func categoryEditingDidEnd() {
        editingCategory.value = nil
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

    // MARK: - Private

    private func addCellViewModel(at indexPath: IndexPath) -> CategoryCellViewModelProtocol {
        let newModel = CategoryCellViewModel()
        cellViewModels.insert(newModel, at: indexPath.item)
        return newModel
    }

    private func removeCellViewModel(at indexPath: IndexPath) {
        cellViewModels.remove(at: indexPath.item)
    }
}
