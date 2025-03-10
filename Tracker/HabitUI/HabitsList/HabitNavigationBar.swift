//
//  HabitNavigationBar.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Class Definition

/// Навигационная панель для управления привычками
final class HabitNavigationBar: UINavigationBar {
    
    // MARK: - Private Properties
    
    private weak var habitBarDelegate: TrackersBarControllerProtocol?
    private lazy var datePicker = { createDatePicker() }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Инициализирует навигационную панель с делегатом
    convenience init(frame: CGRect, habitBarDelegate: TrackersBarControllerProtocol) {
        self.init(frame: frame)
        self.habitBarDelegate = habitBarDelegate
        setupNavigationItems()
    }
    
    // MARK: - Actions
    
    @objc private func addHabitTapped() {
        habitBarDelegate?.addTrackerButtonDidTapped()
    }
    
    @objc private func dateDidChange() {
        habitBarDelegate?.currentDateDidChange(for: datePicker.date)
    }
    
    // MARK: - Private Methods
    
    private func createDatePicker() -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ru_RU")
        picker.addTarget(self, action: #selector(dateDidChange), for: .valueChanged)
        return picker
    }
    
    private func setupNavigationItems() {
        let navigationItem = UINavigationItem()
        let addButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addHabitTapped)
        )
        navigationItem.leftBarButtonItem = addButtonItem
        navigationItem.title = "Трекеры"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        prefersLargeTitles = true
        isTranslucent = false
        tintColor = .ypBlackDay
        setItems([navigationItem], animated: true)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
