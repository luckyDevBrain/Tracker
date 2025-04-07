//
//  DayOfWeekSwitchView.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Class Definition

/// Представление переключателя для выбора дня недели
class DayOfWeekSwitchView: StackCircularSwitch {
    
    // MARK: - Public Properties
    
    var weekday: WeekDay?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(for weekday: WeekDay, isOn: Bool = false) {
        self.init(frame: .zero)
        self.weekday = weekday
        self.isOn = isOn
        let weekdayName = WeekDay.longWeekdayText[weekday] ?? ""
        self.text = weekdayName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
