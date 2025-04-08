//
//  DayOfWeekSwitchView.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

class WeekdaySwitchView: StackRoundedSwitch {

    var weekday: WeekDay?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(for weekday: WeekDay, isOn: Bool = false) {
        self.init(frame: .zero)
        self.weekday = weekday
        self.isOn = isOn
        let weekdayName = WeekDay.longWeekdayText[weekday] ?? ""
        self.text = weekdayName
    }
}
