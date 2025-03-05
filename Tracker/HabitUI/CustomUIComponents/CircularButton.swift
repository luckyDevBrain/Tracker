//
//  CircularButton.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Enums

/// Стили для кнопки с круглыми углами
enum CircularButtonStyle {
    case normal, disabled, cancel
}

// MARK: - Class Definition

/// Кнопка с круглыми углами и различными стилями отображения
class CircularButton: UIButton {
    
    // MARK: - Public Properties
    
    /// Стиль кнопки, определяющий ее внешний вид и поведение
    var circularButtonStyle: CircularButtonStyle = .normal {
        didSet {
            isEnabled = circularButtonStyle != .disabled
            applyStyle()
        }
    }
    
    // MARK: - Private Properties
    
    private var titleText: String = ""
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Инициализирует кнопку с заданным заголовком и стилем
    convenience init(title: String, style: CircularButtonStyle = .normal) {
        self.init(frame: .zero)
        self.circularButtonStyle = style
        self.titleText = title
        translatesAutoresizingMaskIntoConstraints = false
        applyStyle()
    }
    
    // MARK: - Private Methods
    
    private func applyStyle() {
        // Общие настройки
        layer.cornerRadius = 16
        layer.masksToBounds = true
        setTitle(titleText, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel?.textAlignment = .center
        
        // Специфичные настройки для каждого стиля
        switch circularButtonStyle {
        case .cancel:
            backgroundColor = .ypWhiteDay
            layer.borderWidth = 1
            layer.borderColor = UIColor.ypRed.cgColor
            setTitleColor(.ypRed, for: .normal)
        case .normal:
            backgroundColor = .ypBlackDay
            setTitleColor(.ypWhiteDay, for: .normal)
        case .disabled:
            isEnabled = false
            backgroundColor = .ypGray
            setTitleColor(.ypWhiteDay, for: .normal)
        }
    }
}
