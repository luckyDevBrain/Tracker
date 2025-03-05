//
//  TitleLabel.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Class Definition

/// Метка для заголовков с предустановленным стилем
final class TitleLabel: UILabel {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Инициализирует метку с заданным заголовком
    convenience init(title: String) {
        self.init(frame: .zero)
        setupTitle(title: title)
    }
    
    // MARK: - Private Methods
    
    /// Настраивает стиль и текст метки
    private func setupTitle(title: String) {
        text = title
        font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textColor = .ypBlackDay
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
    }
}
