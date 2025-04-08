//
//  CategoryCellViewModel.swift
//  Tracker
//
//  Created by Kirill on 08.04.2025.
//

import Foundation

struct CategoryCellViewModelBindings {
    let categoryName: (String?) -> Void
    let isSelected: (Bool?) -> Void
}

protocol CategoryCellViewModelProtocol {
    func setBinidings(_ bindings: CategoryCellViewModelBindings)
    func setupModelWith(categoryName: String, isSelected: Bool)
    func didSelectRow()
    func didDeselectRow()
}

final class CategoryCellViewModel: CategoryCellViewModelProtocol {

    @Observable
    private var categoryName: String?

    @Observable
    private var isSelected: Bool?

    func setBinidings(_ bindings: CategoryCellViewModelBindings) {
        self.$categoryName.bind(action: bindings.categoryName)
        self.$isSelected.bind(action: bindings.isSelected)
    }

    func setupModelWith(categoryName: String, isSelected: Bool) {
        self.categoryName = categoryName
        self.isSelected = isSelected
    }

    func didSelectRow() {
        isSelected = true
    }

    func didDeselectRow() {
        isSelected = false
    }
}
