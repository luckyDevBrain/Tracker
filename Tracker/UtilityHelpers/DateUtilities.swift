//
//  DateUtilities.swift
//  Tracker
//
//  Created by Kirill on 24.03.2025.
//

import Foundation

// MARK: - Extensions

/// Расширение для Date с методами сравнения и усечения
extension Date {
    
    // MARK: - Public Methods
    
    /// Сравнивает даты с заданной точностью
    func isEqual(to date: Date?, toGranularity component: Calendar.Component = .day) -> Bool {
        guard let date else { return false }
        return Calendar.current.compare(self, to: date, toGranularity: component) == .orderedSame
    }
    
    /// Проверяет, является ли текущая дата больше другой
    func isGreater(than date: Date?, toGranularity component: Calendar.Component = .day) -> Bool {
        guard let date else { return false }
        return Calendar.current.compare(self, to: date, toGranularity: component) == .orderedDescending
    }
    
    /// Усекает дату до начала дня в UTC
    func truncated() -> Date? {
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        guard let utcTimeZone = TimeZone(abbreviation: "UTC") else { return nil }
        dateComponents.timeZone = utcTimeZone
        return Calendar.current.date(from: dateComponents)
    }
}
