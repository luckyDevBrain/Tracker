//
//  HabitNameInputFooterView.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Class Definition

/// Кастомный футер для ввода названия привычки с предупреждением о лимите символов
class HabitNameInputFooterView: UIView {
    
    // MARK: - Private Properties
    
    private let characterLimitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypRed
        label.textAlignment = .center
        label.text = "Максимум 38 символов"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    /// Инициализирует футер с заданным фреймом
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    /// Инициализирует футер из storyboard или nib
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    /// Настраивает содержимое и констрейнты футера
    private func setupView() {
        addSubview(characterLimitLabel)
        NSLayoutConstraint.activate([
            characterLimitLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            characterLimitLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            characterLimitLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            characterLimitLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
