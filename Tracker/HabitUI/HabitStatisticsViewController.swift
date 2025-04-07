//
//  HabitStatisticsViewController.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Class Definition

final class StatisticsViewController: UIViewController {

    // MARK: - Private Properties
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Продолжение следует..."
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .ypWhiteDay
        setupLabel()
    }

    private func setupLabel() {
        
        view.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
