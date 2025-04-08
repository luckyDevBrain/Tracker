//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import Foundation

// MARK: - Structs

/// Структура для категорий трекеров
struct TrackerCategory {
    
    // MARK: - Public Properties
    
    /// Уникальный идентификатор категории
    let categoryID: UUID
    
    let name: String
    
    // MARK: - Initializers
    
    init(
        id: UUID,
        name: String
    ) {
        self.categoryID = id
        self.name = name
    }
}
