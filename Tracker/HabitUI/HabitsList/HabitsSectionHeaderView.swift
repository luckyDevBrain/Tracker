//
//  HabitsSectionHeaderView.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Class Definition

/// Заголовок секции для отображения категорий привычек
final class HabitsSectionHeaderView: UICollectionReusableView {
    
    // MARK: - Static Properties
    
    static let viewIdentifier = "habitsSectionHeader"
    
    // MARK: - Public Properties
    
    /// Метка для текста заголовка секции
    let headerLabel = UILabel()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        headerLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            headerLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
