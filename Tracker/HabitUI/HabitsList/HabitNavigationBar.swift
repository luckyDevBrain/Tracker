//
//  HabitNavigationBar.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

final class TrackerNavigationBar: UINavigationBar {

    private weak var trackerBarDelegate: TrackersBarControllerProtocol?
    private lazy var datePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale.current
        datePicker.addTarget(self, action: #selector(currentDateDidChange), for: .valueChanged)
        return datePicker
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(frame: CGRect,
                     trackerBarDelegate: TrackersBarControllerProtocol) {
        self.init(frame: frame)

        let navigationItem = UINavigationItem()
        let leftBarItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(createTrackerTapped))
        leftBarItem.imageInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 0)
        layoutMargins.left = 16
        navigationItem.leftBarButtonItem = leftBarItem
        navigationItem.title = "trackersList.title".localized()
        navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: datePicker)

        self.trackerBarDelegate = trackerBarDelegate
        prefersLargeTitles = true
        isTranslucent = false
        tintColor = .ypBlackDay
        setItems([navigationItem], animated: true)
        translatesAutoresizingMaskIntoConstraints = false
    }

    func setDatePickerDate(to date: Date) {
        datePicker.date = date
    }

    @objc private func createTrackerTapped() {
        trackerBarDelegate?.addTrackerButtonDidTapped()
    }

    @objc private func currentDateDidChange() {
        trackerBarDelegate?.currentDateDidChange(for: datePicker.date)
    }
}
