//
//  DayOfWeekSwitchView.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Class Definition

/// Переключатель для выбора дня недели с отображением названия
final class DayOfWeekSwitchView: StackCircularSwitch {
    
    // MARK: - Public Properties
    
    /// День недели, связанный с переключателем
    var weekday: WeekDay?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Инициализирует переключатель для указанного дня недели
    convenience init(for weekday: WeekDay, isOn: Bool = false) {
        self.init(frame: .zero)
        configure(with: weekday, isOn: isOn)
    }
    
    // MARK: - Private Methods
    
    private func configure(with weekday: WeekDay, isOn: Bool) {
        self.weekday = weekday
        self.isOn = isOn
        text = WeekDay.getLongText(for: weekday)
    }
}
