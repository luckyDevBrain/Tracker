//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Kirill on 24.03.2025.
//

import Foundation

// MARK: - Structs

/// Структура для представления категории трекера
struct TrackerCategoryStore {
    
    // MARK: - Public Properties
    
    let categoryID: UUID
    let name: String
    
    // MARK: - Initializers
    
    init(categoryID: UUID, name: String) {
        self.categoryID = categoryID
        self.name = name
    }
    
    init(categoryCoreData: TrackerCategoryCoreData) {
        self.init(
            categoryID: categoryCoreData.categoryID ?? UUID(),
            name: categoryCoreData.name ?? ""
        )
    }
}
