//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import Foundation

// MARK: - Structs

/// Структура для записи выполнения трекера
struct TrackerRecord: Hashable {
    
    // MARK: - Public Properties
    
    /// Уникальный идентификатор трекера
    let trackerID: UUID
    
    /// Дата завершения
    let dateCompleted: Date
}

// MARK: - Extensions

extension TrackerRecord {
    
    // MARK: - Public Methods
    
    /// Проверяет, выполнен ли трекер за последние 7 дней
    /// - Returns: True, если трекер завершен в течение последней недели, иначе false
    func completedWithinLastWeek() -> Bool {
        let calendar = Calendar.current
        guard let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) else {
            return false
        }
        return dateCompleted >= oneWeekAgo
    }
}
