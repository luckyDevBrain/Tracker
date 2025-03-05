//
//  HabitStatisticsViewController.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Class Definition

/// Контроллер для отображения статистики привычек (заглушка)
final class HabitStatisticsViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var placeholderLabel = { createPlaceholderLabel() }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .ypWhiteDay
        view.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func createPlaceholderLabel() -> UILabel {
        let label = UILabel()
        label.text = "Продолжение следует..."
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
