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
    
    // MARK: - Static Properties
    
    /// Список всех дней недели с учетом первого дня недели в текущем календаре
    static var allWeekdays: [WeekDay] {
        let firstDay = Calendar.current.firstWeekday
        return (firstDay...7).compactMap { WeekDay(rawValue: $0) }
            + (1..<firstDay).compactMap { WeekDay(rawValue: $0) }
    }
    
    /// Короткие текстовые обозначения дней недели
    static let shortWeekdayText: [WeekDay: String] = [
        .sun: "Вс",
        .mon: "Пн",
        .tue: "Вт",
        .wed: "Ср",
        .thu: "Чт",
        .fri: "Пт",
        .sat: "Сб"
    ]
    
    /// Полные текстовые названия дней недели
    static let longWeekdayText: [WeekDay: String] = [
        .sun: "Воскресенье",
        .mon: "Понедельник",
        .tue: "Вторник",
        .wed: "Среда",
        .thu: "Четверг",
        .fri: "Пятница",
        .sat: "Суббота"
    ]
    
    // MARK: - Static Methods
    
    /// Возвращает короткое текстовое обозначение дня недели
    /// - Parameter day: День недели
    /// - Returns: Краткое название (например, "Пн" для понедельника)
    static func getShortText(for day: WeekDay) -> String {
        shortWeekdayText[day] ?? ""
    }
    
    /// Возвращает полное текстовое название дня недели
    /// - Parameter day: День недели
    /// - Returns: Полное название (например, "Понедельник")
    static func getLongText(for day: WeekDay) -> String {
        longWeekdayText[day] ?? ""
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
    
    /// Преобразует строку с короткими названиями дней недели в массив дней
    /// - Parameter string: Строка с днями недели (например, "Пн, Ср")
    /// - Returns: Массив дней недели
    static func getWeekDays(from string: String) -> [WeekDay] {
        let invertedShortWD = Dictionary(
            uniqueKeysWithValues: shortWeekdayText.map { ($0.value.lowercased(), $0.key) }
        )
        return string.split(separator: ",").compactMap {
            let normalizedWeekDay = $0.trimmingCharacters(in: .whitespaces).lowercased()
            return invertedShortWD[normalizedWeekDay]
        }
    }
}
