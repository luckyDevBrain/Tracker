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
    
    /// Название категории
    let name: String
    
    /// Трекеры, входящие в категорию
    let trackersInCategory: [Tracker]
    
    // MARK: - Initializers
    
    /// Инициализатор категории трекеров
    /// - Parameters:
    ///   - categoryID: Уникальный идентификатор категории (по умолчанию генерируется автоматически)
    ///   - name: Название категории
    ///   - trackersInCategory: Массив трекеров в категории (по умолчанию пустой)
    init(
        categoryID: UUID = UUID(),
        name: String,
        trackersInCategory: [Tracker] = []
    ) {
        self.categoryID = categoryID
        self.name = name
        self.trackersInCategory = trackersInCategory
    }
    
    // MARK: - Public Methods
    
    /// Возвращает отсортированный по алфавиту список трекеров в категории
    /// - Returns: Отсортированный массив трекеров или nil, если трекеров нет
    func sortedTrackers() -> [Tracker]? {
        guard !trackersInCategory.isEmpty else { return nil }
        return trackersInCategory.sorted { $0.name < $1.name }
    }
}
