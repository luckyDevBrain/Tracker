//
//  StackCircularSwitch.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Class Definition

/// Представление с переключателем в стиле StackRoundedView
class StackCircularSwitch: StackCircularView {
    
    // MARK: - Public Properties
    
    var isOn: Bool {
        get {
            return switchView.isOn
        }
        set {
            switchView.isOn = newValue
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var switchView = { createSwitchView() }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(switchView)
        
        NSLayoutConstraint.activate([
            switchView.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func createSwitchView() -> UISwitch {
        let switchView = UISwitch()
        switchView.setOn(false, animated: true)
        switchView.onTintColor = .ypBlue
        switchView.translatesAutoresizingMaskIntoConstraints = false
        return switchView
    }
}
