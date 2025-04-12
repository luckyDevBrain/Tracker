//
//  CategoryCellViewModel.swift
//  Tracker
//
//  Created by Kirill on 08.04.2025.
//

import Foundation
import Combine

struct CategoryCellViewModelBindings {
    let categoryName: (String?) -> Void
    let isSelected: (Bool?) -> Void
}

protocol CategoryCellViewModelProtocol {
    func setBindings(_ bindings: CategoryCellViewModelBindings)
    func setupModelWith(categoryName: String, isSelected: Bool)
    func didSelectRow()
    func didDeselectRow()
}

final class CategoryCellViewModel: CategoryCellViewModelProtocol {

    @Published private var categoryName: String?
    @Published private var isSelected: Bool?

    private var cancellables = Set<AnyCancellable>()

    func setBindings(_ bindings: CategoryCellViewModelBindings) {
        $categoryName
            .sink(receiveValue: bindings.categoryName)
            .store(in: &cancellables)

        $isSelected
            .sink(receiveValue: bindings.isSelected)
            .store(in: &cancellables)
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
