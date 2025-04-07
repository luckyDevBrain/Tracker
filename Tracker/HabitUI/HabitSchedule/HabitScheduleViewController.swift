//
//  HabitScheduleViewController.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Class Definition

/// Контроллер для настройки расписания трекера
final class HabitScheduleViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var schedule: [WeekDay]?
    weak var saveScheduleDelegate: ScheduleSaverDelegate?
    
    // MARK: - Private Properties
    
    private lazy var scheduleStackView = { createScheduleStackView() }()
    private lazy var okButton = { CircularButton(title: "Готово") }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    // MARK: - Actions
    
    @objc private func okButtonTapped() {
        schedule = scheduleStackView.arrangedSubviews.compactMap { weekdayView in
            guard let weekdayView = weekdayView as? DayOfWeekSwitchView else { return nil }
            return weekdayView.isOn ? weekdayView.weekday : nil
        }
        guard let schedule else { return }
        saveScheduleDelegate?.scheduleDidSetup(with: schedule)
    }
}

// MARK: - Extensions

// MARK: - Layout
private extension HabitScheduleViewController {
    func createScheduleStackView() -> CircularViewsStackView {
        let arrangedSubviews = WeekDay.allWeekdays.map {
            DayOfWeekSwitchView(for: $0, isOn: schedule?.contains($0) ?? false)
        }
        let scheduleStack = CircularViewsStackView(arrangedSubviews: arrangedSubviews)
        scheduleStack.translatesAutoresizingMaskIntoConstraints = false
        return scheduleStack
    }
    
    func createScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.addSubview(scheduleStackView)
        
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        scrollView.addSubview(okButton)
        
        return scrollView
    }
    
    func setupSubviews() {
        view.backgroundColor = .ypWhiteDay
        
        let titleLabel = TitleLabel(title: "Расписание")
        view.addSubview(titleLabel)
        
        let scrollView = createScrollView()
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scheduleStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scheduleStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scheduleStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scheduleStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            
            okButton.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            okButton.topAnchor.constraint(equalTo: scheduleStackView.bottomAnchor, constant: 24),
            okButton.heightAnchor.constraint(equalToConstant: 60),
            okButton.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            okButton.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
}
