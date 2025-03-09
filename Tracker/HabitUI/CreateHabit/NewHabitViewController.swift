//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Protocol

protocol ScheduleSaverDelegate: AnyObject {
    func scheduleDidSetup(with newSchedule: [WeekDay])
}

// MARK: - Class Definition

/// Контроллер для создания новой привычки или нерегулярного события
final class NewHabitViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var habitSaverDelegate: HabitSaverDelegate?
    var isRegular: Bool!
    var categories: [TrackerCategory] = []
    
    // MARK: - Private Properties
    
    private var trackerName: String? {
        didSet {
            checkIsAllParametersDidSetup()
        }
    }
    private var category: TrackerCategory? {
        didSet {
            displayCategory()
            checkIsAllParametersDidSetup()
        }
    }
    private var schedule: [WeekDay]? {
        didSet {
            checkIsAllParametersDidSetup()
        }
    }
    private var isAllParametersDidSetup = false {
        didSet {
            doneButton.circularButtonStyle = isAllParametersDidSetup ? .normal : .disabled
        }
    }
    
    private lazy var inputTrackerNameTxtField = { createTextField() }()
    private lazy var categorySetupButton = { createCategorySetupButton() }()
    private lazy var scheduleSetupButton = { createScheduleSetupButton() }()
    private lazy var emojiCollectionView = { createCollectionView(title: "Emoji") }()
    private lazy var colorCollectionView = { createCollectionView(title: "Цвет") }()
    private lazy var cancelButton = { createCancelButton() }()
    private lazy var doneButton = { createDoneButton() }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        displayData()
        let anyTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAnyTap))
        view.addGestureRecognizer(anyTapGesture)
        
        // Используем новый метод для подписки на событие editingChanged
        inputTrackerNameTxtField.addTargetForEditingChanged(self, action: #selector(textFieldDidChange))
        
        // Устанавливаем категорию по умолчанию из переданного массива categories
        if !categories.isEmpty {
            category = categories.first
        } else {
            // Если categories пуст, создаём новую категорию как запасной вариант
            category = TrackerCategory(
                categoryID: UUID(),
                name: "Занятия спортом",
                trackersInCategory: []
            )
        }
    }
    
    // MARK: - Actions
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        trackerName = textField.text
        checkIsAllParametersDidSetup()
    }
    
    @objc private func handleAnyTap() {
        trackerName = inputTrackerNameTxtField.inputText
        _ = inputTrackerNameTxtField.resignFirstResponder()
        checkIsAllParametersDidSetup()
    }
    
    @objc private func categoryButtonDidTap() {
        print("Category did tap")
    }
    
    @objc private func scheduleButtonDidTap() {
        _ = inputTrackerNameTxtField.resignFirstResponder()
        trackerName = inputTrackerNameTxtField.inputText
        let scheduleViewController = HabitScheduleViewController()
        scheduleViewController.schedule = schedule
        scheduleViewController.saveScheduleDelegate = self
        present(scheduleViewController, animated: true)
    }
    
    @objc private func doneButtonDidTap() {
        guard let categoryID = category?.categoryID else {
            assertionFailure("Не удалось определить категорию трекера при сохранении")
            return
        }
        if inputTrackerNameTxtField.isFirstResponder {
            if inputTrackerNameTxtField.resignFirstResponder() {
                trackerName = inputTrackerNameTxtField.inputText
            } else {
                assertionFailure("Не удалось завершить ввод названия трекера при сохранении")
                return
            }
        }
        guard let trackerName, !trackerName.isEmpty else {
            assertionFailure("Не удалось определить название трекера при сохранении")
            return
        }
        let newTracker = Tracker(name: trackerName, isRegular: isRegular, emoji: "🏓", color: .ypColorSelection11, schedule: schedule)
        habitSaverDelegate?.save(tracker: newTracker, in: categoryID)
    }
    
    @objc private func cancelButtonDidTap() {
        dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    
    private func checkIsAllParametersDidSetup() {
        isAllParametersDidSetup = trackerName?.isEmpty == false
        && (!isRegular || schedule?.isEmpty == false)
        && (category?.name.isEmpty == false)
        print("trackerName: \(trackerName ?? "nil"), isRegular: \(isRegular ?? false), schedule: \(schedule?.description ?? "nil"), category: \(category?.name ?? "nil"), isAllParametersDidSetup: \(isAllParametersDidSetup)")
    }
    
    private func displaySchedule() {
        scheduleSetupButton.detailedText = schedule == nil ? "" : WeekDay.getDescription(for: schedule!)
    }
    
    private func displayCategory() {
        categorySetupButton.detailedText = category?.name ?? ""
    }
    
    private func displayData() {
        displaySchedule()
        displayCategory()
    }
}

// MARK: - ScheduleSaverDelegate

extension NewHabitViewController: ScheduleSaverDelegate {
    func scheduleDidSetup(with newSchedule: [WeekDay]) {
        self.schedule = newSchedule
        displaySchedule()
        dismiss(animated: true)
        checkIsAllParametersDidSetup()
    }
}

// MARK: - UITextFieldDelegate

extension NewHabitViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 38
        let currentString = textField.text as? NSString
        let newString = currentString?.replacingCharacters(in: range, with: string) ?? ""
        if newString.count > maxLength {
            inputTrackerNameTxtField.shouldHideMaxLengthHint = false
        } else if !inputTrackerNameTxtField.shouldHideMaxLengthHint {
            inputTrackerNameTxtField.shouldHideMaxLengthHint = true
        }
        return newString.count <= maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        trackerName = textField.text
        checkIsAllParametersDidSetup()
    }
}

// MARK: - Layout

private extension NewHabitViewController {
    func createTitleLabel() -> TitleLabel {
        let titleText = isRegular ? "Новая привычка" : "Новое нерегулярное событие"
        return TitleLabel(title: titleText)
    }
    
    func createTextField() -> HabitNameInputView {
        let textField = HabitNameInputView(delegate: self, placeholder: "Назови свою привычку")
        return textField
    }
    
    func createCategorySetupButton() -> StackCircularView {
        let categoryButton = StackCircularButton(target: self, action: #selector(categoryButtonDidTap))
        categoryButton.circularCornerStyle = isRegular ? .topOnly : .topAndBottom
        categoryButton.text = "Категория"
        return categoryButton
    }
    
    func createScheduleSetupButton() -> StackCircularView {
        let scheduleButton = StackCircularButton(target: self, action: #selector(scheduleButtonDidTap))
        scheduleButton.circularCornerStyle = .bottomOnly
        scheduleButton.text = "Расписание"
        return scheduleButton
    }
    
    func createActionButtonsView() -> UIView {
        let stack = UIStackView()
        stack.addArrangedSubview(categorySetupButton)
        if isRegular {
            stack.addArrangedSubview(scheduleSetupButton)
        }
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    func createCollectionView(title titleText: String) -> UIView {
        let collectionView = UIView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let title = UILabel()
        title.text = titleText
        title.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        title.textColor = .ypBlackDay
        title.textAlignment = .left
        title.translatesAutoresizingMaskIntoConstraints = false
        collectionView.addSubview(title)
        
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collectionView.addSubview(collection)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 28),
            title.topAnchor.constraint(equalTo: collectionView.topAnchor),
            
            collection.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            collection.topAnchor.constraint(equalTo: title.bottomAnchor),
            collection.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            collection.heightAnchor.constraint(equalToConstant: 192),
            collection.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
        ])
        return collectionView
    }
    
    func createDoneButton() -> CircularButton {
        let button = CircularButton(title: "Сохранить")
        button.circularButtonStyle = isAllParametersDidSetup ? .normal : .disabled
        button.addTarget(self, action: #selector(doneButtonDidTap), for: .touchUpInside)
        return button
    }
    
    func createCancelButton() -> CircularButton {
        let button = CircularButton(title: "Отменить", style: .cancel)
        button.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
        return button
    }
    
    func createScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 16, right: 0)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(inputTrackerNameTxtField)
        let actionButtonsView = createActionButtonsView()
        scrollView.addSubview(actionButtonsView)
        scrollView.addSubview(emojiCollectionView)
        scrollView.addSubview(colorCollectionView)
        
        let buttons = UIStackView(arrangedSubviews: [cancelButton, doneButton])
        buttons.axis = .horizontal
        buttons.spacing = 8
        buttons.distribution = .fillEqually
        buttons.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(buttons)
        
        NSLayoutConstraint.activate([
            inputTrackerNameTxtField.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            inputTrackerNameTxtField.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            inputTrackerNameTxtField.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            
            actionButtonsView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            actionButtonsView.topAnchor.constraint(equalTo: inputTrackerNameTxtField.bottomAnchor, constant: 24),
            actionButtonsView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            
            emojiCollectionView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            emojiCollectionView.topAnchor.constraint(equalTo: actionButtonsView.bottomAnchor, constant: 32),
            emojiCollectionView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            
            colorCollectionView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            colorCollectionView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            
            buttons.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            buttons.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
            buttons.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            buttons.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40),
            buttons.heightAnchor.constraint(equalToConstant: 60),
            buttons.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
        ])
        
        return scrollView
    }
    
    func setupSubviews() {
        view.backgroundColor = .ypWhiteDay
        let title = createTitleLabel()
        view.addSubview(title)
        let scrollView = createScrollView()
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: title.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
