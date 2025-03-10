//
//  WeekDay.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import Foundation

// MARK: - Enums

/// Перечисление дней недели с поддержкой текстового представления
enum WeekDay: Int, CaseIterable {
    case sun = 1, mon, tue, wed, thu, fri, sat
    
    // MARK: - Public Properties
    
    /// Список всех дней недели с учетом первого дня недели в текущем календаре
    static var allWeekdays: [WeekDay] {
        let firstDay = Calendar.current.firstWeekday
        return (firstDay...7).compactMap { WeekDay(rawValue: $0) }
            + (1..<firstDay).compactMap { WeekDay(rawValue: $0) }
    }
    
    // MARK: - Public Methods
    
    /// Возвращает короткое текстовое обозначение дня недели
    /// - Parameter day: День недели
    /// - Returns: Краткое название (например, "Пн" для понедельника)
    static func getShortText(for day: WeekDay) -> String {
        switch day {
        case .sun: return "Вс"
        case .mon: return "Пн"
        case .tue: return "Вт"
        case .wed: return "Ср"
        case .thu: return "Чт"
        case .fri: return "Пт"
        case .sat: return "Сб"
        }
    }
    
    /// Возвращает полное текстовое название дня недели
    /// - Parameter day: День недели
    /// - Returns: Полное название (например, "Понедельник")
    static func getLongText(for day: WeekDay) -> String {
        switch day {
        case .sun: return "Воскресенье"
        case .mon: return "Понедельник"
        case .tue: return "Вторник"
        case .wed: return "Среда"
        case .thu: return "Четверг"
        case .fri: return "Пятница"
        case .sat: return "Суббота"
        }
    }
    
    /// Формирует текстовое описание расписания на основе выбранных дней
    /// - Parameter schedule: Массив выбранных дней недели
    /// - Returns: Строка с описанием (например, "Пн, Ср" или "Каждый день")
    static func getDescription(for schedule: [WeekDay]) -> String {
        if schedule.isEmpty { return "Нет дней" }
        if schedule.count == allCases.count { return "Каждый день" }
        let sortedDays = schedule.sorted { $0.rawValue < $1.rawValue }
        return sortedDays.map { getShortText(for: $0) }.joined(separator: ", ")
    }
}
