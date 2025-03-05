//
//  StackCircularSwitch.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

/// Переключатель с круглыми углами и настраиваемым состоянием
class StackCircularSwitch: StackCircularView {
    
    // MARK: - Public Properties
    
    /// Состояние переключателя (включен/выключен)
    var isOn: Bool {
        get {
            return switchControl.isOn
        }
        set {
            switchControl.isOn = newValue
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var switchControl = { createSwitchControl() }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSwitch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupSwitch() {
        addSubview(switchControl)
        
        NSLayoutConstraint.activate([
            switchControl.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func createSwitchControl() -> UISwitch {
        let switchView = UISwitch()
        switchView.setOn(false, animated: true)
        switchView.onTintColor = .ypBlue
        switchView.translatesAutoresizingMaskIntoConstraints = false
        return switchView
    }
}
