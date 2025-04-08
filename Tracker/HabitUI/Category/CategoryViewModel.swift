//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Kirill on 08.04.2025.
//

import Foundation

struct CategoryViewModelBindings {
    let isOkButtonEnabled: (Bool?) -> Void
    let isCategoryDidCreated: (Bool?) -> Void
}

protocol CategoryViewModelProtocol {
    func setBindings(_ bindings: CategoryViewModelBindings)
    func viewDidLoad()
    func textFieldDidChange(to text: String?)
    func okButtonDidTap()
    func getInitialCategoryName() -> String
}

final class CategoryViewModel: CategoryViewModelProtocol {
    var saveCategory: ((TrackerCategory) -> Void)?

    private var isOkButtonEnabled = ObservableBox<Bool?>(false)
    private var isCategoryDidCreated = ObservableBox<Bool?>(false)

    private var categoryName: String?
    private var category: TrackerCategory

    init(categoryToEdit: TrackerCategory? = nil) {
        self.category = categoryToEdit ?? TrackerCategory(id: UUID(), name: "")
    }

    func setBindings(_ bindings: CategoryViewModelBindings) {
        isOkButtonEnabled.bind(bindings.isOkButtonEnabled)
        isCategoryDidCreated.bind(bindings.isCategoryDidCreated)
    }

    func viewDidLoad() {
        isOkButtonEnabled.value = false
        textFieldDidChange(to: category.name)
    }

    func textFieldDidChange(to text: String?) {
        let normalizedName = normalized(categoryName: text)
        isOkButtonEnabled.value = !normalizedName.isEmpty
        categoryName = normalizedName
    }

    func okButtonDidTap() {
        guard let categoryName else { return }
        let updatedCategory = TrackerCategory(id: category.categoryID, name: categoryName)
        saveCategory?(updatedCategory)
        isCategoryDidCreated.value = true
    }

    func getInitialCategoryName() -> String {
        category.name
    }

    private func normalized(categoryName text: String?) -> String {
        return text?.trimmingCharacters(in: .whitespaces) ?? ""
    }
}
