//
//  HabitNavigationBar.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Class Definition

final class HabitNavigationBar: UINavigationBar {
    
    // MARK: - Private Properties
    
    private weak var trackerBarDelegate: TrackersBarControllerProtocol?
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ru_RU")
        picker.addTarget(self, action: #selector(currentDateDidChange), for: .valueChanged)
        return picker
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect,
                     trackerBarDelegate: TrackersBarControllerProtocol) {
        self.init(frame: frame)
        self.trackerBarDelegate = trackerBarDelegate
        
        configureNavigationBar()
    }
    
    // MARK: - Actions
    
    @objc private func createTrackerTapped() {
        trackerBarDelegate?.addTrackerButtonDidTapped()
    }
    
    @objc private func currentDateDidChange() {
        trackerBarDelegate?.currentDateDidChange(for: datePicker.date)
    }
    
    // MARK: - Private Methods
    
    private func configureNavigationBar() {
        let navigationItem = UINavigationItem()
        
        let leftBarItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(createTrackerTapped)
        )
        leftBarItem.imageInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 0)
        
        navigationItem.leftBarButtonItem = leftBarItem
        navigationItem.title = "Трекеры"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        configureAppearance()
        setItems([navigationItem], animated: true)
    }
    
    private func configureAppearance() {
        layoutMargins.left = 16
        prefersLargeTitles = true
        isTranslucent = false
        tintColor = .ypBlackDay
        translatesAutoresizingMaskIntoConstraints = false
    }
}
