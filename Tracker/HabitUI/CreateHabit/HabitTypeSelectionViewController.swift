//
//  HabitTypeSelectionViewController.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Class Definition

/// Контроллер для выбора типа создаваемого трекера
final class HabitTypeSelectionViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var saverDelegate: NewTrackerSaverDelegate?
    var dataProvider: DataProviderProtocol?
    
    // MARK: - Private Properties
    
    private lazy var habitButton = { CircularButton(title: "Привычка") }()
    private lazy var irregularEventButton = { CircularButton(title: "Нерегулярное событие") }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        addButtonTargets()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Actions
    
    @objc private func habitButtonDidTap() {
        createTracker(isRegular: true)
    }
    
    @objc private func irregularEventButtonDidTap() {
        createTracker(isRegular: false)
    }
    
    // MARK: - Private Methods
    
    private func createTracker(isRegular: Bool) {
        let viewController = NewHabitViewController()
        viewController.isRegular = isRegular
        viewController.saverDelegate = saverDelegate
        viewController.dataProvider = dataProvider
        present(viewController, animated: true)
    }
    
    private func addButtonTargets() {
        habitButton.addTarget(
            self,
            action: #selector(habitButtonDidTap),
            for: .touchUpInside
        )
        irregularEventButton.addTarget(
            self,
            action: #selector(irregularEventButtonDidTap),
            for: .touchUpInside
        )
    }
}

// MARK: - Extensions

// MARK: - Layout
private extension HabitTypeSelectionViewController {
    func setupSubviews() {
        view.backgroundColor = .ypWhiteDay
        
        let titleLabel = TitleLabel(title: "Создание трекера")
        view.addSubview(titleLabel)
        
        let vButtonStackView = UIStackView(arrangedSubviews: [habitButton, irregularEventButton])
        vButtonStackView.axis = .vertical
        vButtonStackView.spacing = 16
        
        vButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vButtonStackView)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            
            vButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vButtonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            vButtonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            vButtonStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 43),
            
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            irregularEventButton.heightAnchor.constraint(equalTo: habitButton.heightAnchor),
        ])
    }
}
