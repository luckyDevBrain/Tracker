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
    let trackerID: UUID
    
    /// Заголовок трекера
    let name: String
    
    /// Флаг регулярности: true - привычка, false - разовое событие
    let isRegular: Bool
    
    /// Символ эмодзи для трекера
    let emoji: String
    
    /// Цветовая схема трекера
    let color: UIColor.YpColors?
    
    /// расписание трекера. Устанавливается для регулярных привычек
    let schedule: [WeekDay]?
    
    /// true - карточка отмечена выполненной
    let isCompleted: Bool
    
    /// счетчик количества выполненных
    let completedCounter: Int
    
    /// признак закрепленности трекера: true - трекер закреплен, false - незакреплен
        let isPinned: Bool
    }
