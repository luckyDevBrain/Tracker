//
//  HabitTypeSelectionViewController.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Class Definition

final class HabitTypeSelectionViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var habitSaverDelegate: HabitSaverDelegate?
    
    // MARK: - Private Properties
    
    private lazy var regularHabitButton = { CircularButton(title: "Привычка") }()
    private lazy var irregularEventButton = { CircularButton(title: "Нерегулярное событие") }()
    
    // MARK: - Lifecycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            setupButtonActions()
        }

        // MARK: - Private Methods

        private func handleHabitCreation(isRegular: Bool) {
            let trackerVC = NewHabitViewController()
            trackerVC.isRegular = isRegular
            trackerVC.habitSaverDelegate = habitSaverDelegate
            trackerVC.categories = (habitSaverDelegate as? HabitsViewController)?.categories ?? []
            present(trackerVC, animated: true)
        }

        private func setupButtonActions() {
            regularHabitButton.addTarget(
                self,
                action: #selector(regularHabitButtonTapped),
                for: .touchUpInside
            )
            irregularEventButton.addTarget(
                self,
                action: #selector(irregularEventButtonTapped),
                for: .touchUpInside
            )
        }

        // MARK: - Actions

        @objc private func regularHabitButtonTapped() {
            handleHabitCreation(isRegular: true)
        }

        @objc private func irregularEventButtonTapped() {
            handleHabitCreation(isRegular: false)
        }
    }

    // MARK: - UI Setup

    private extension HabitTypeSelectionViewController {

        func setupUI() {
            view.backgroundColor = .ypWhiteDay
            setupTitleLabel()
            setupButtonStack()
        }

        func setupTitleLabel() {
            let titleLabel = UILabel()
            titleLabel.text = "Создание трекера"
            titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            titleLabel.textColor = .ypBlackDay
            titleLabel.textAlignment = .center
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(titleLabel)

            NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27)
            ])
        }

        func setupButtonStack() {
            let buttonStack = UIStackView(arrangedSubviews: [regularHabitButton, irregularEventButton])
            buttonStack.axis = .vertical
            buttonStack.spacing = 16
            buttonStack.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(buttonStack)

            NSLayoutConstraint.activate([
                buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                buttonStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 43),

                regularHabitButton.heightAnchor.constraint(equalToConstant: 60),
                irregularEventButton.heightAnchor.constraint(equalTo: regularHabitButton.heightAnchor)
            ])
        }
    }
