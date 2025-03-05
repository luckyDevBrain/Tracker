//
//  StringUtilities.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import Foundation

// MARK: - Class Definition

/// Утилита для работы со строками, включая форматирование чисел
final class StringUtilities {
    
    // MARK: - Static Methods
    
    /// Возвращает правильный суффикс для слова "день" в зависимости от количества дней
    /// - Parameter daysCount: Количество дней
    /// - Returns: Суффикс: "день", "дня" или "дней"
    static func getDaysText(for daysCount: Int) -> String {
        let remainder100 = daysCount % 100
        
        // Особый случай для чисел 11–14, всегда "дней"
        if remainder100 >= 11 && remainder100 <= 14 {
            return "дней"
        }
        
        // Определение суффикса по последней цифре числа
        let lastDigit = daysCount % 10
        switch lastDigit {
        case 1:
            return "день"
        case 2, 3, 4:
            return "дня"
        default:
            return "дней"
        }
    }
}
