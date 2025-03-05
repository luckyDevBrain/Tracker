//
//  Tracker.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Structs

/// Структура, описывающая трекер привычек или разовых событий
struct Tracker {
    
    // MARK: - Public Properties
    
    /// Уникальный идентификатор трекера
    let trackerID = UUID()
    
    /// Заголовок трекера
    let name: String
    
    /// Флаг регулярности: true - привычка, false - разовое событие
    let isRegular: Bool
    
    /// Символ эмодзи для трекера
    let emoji: String
    
    /// Цветовая схема трекера
    let color: UIColor
    
    /// График выполнения для регулярных привычек
    let schedule: [WeekDay]?
}
