//
//  HabitNameInputView.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Class Definition

/// Стек для ввода названия привычки с подсказкой о максимальной длине
final class HabitNameInputView: UIStackView {
    
    // MARK: - Public Properties
    
    /// Скрывает или показывает подсказку о максимальной длине
    var shouldHideMaxLengthHint = true {
        didSet {
            maxLengthHintView.isHidden = shouldHideMaxLengthHint
        }
    }
    
    /// Текст, введенный пользователем
    var inputText: String {
        habitNameTextField.text ?? ""
    }
    
    /// Делегат для обработки событий текстового поля
    weak var inputDelegate: UITextFieldDelegate? {
        didSet {
            habitNameTextField.delegate = inputDelegate
        }
    }
    
    /// Проверяет, активно ли текстовое поле
    override var isFirstResponder: Bool {
        habitNameTextField.isFirstResponder
    }
    
    // MARK: - Private Properties
    
    private lazy var habitNameTextField = { createTextField() }()
    private lazy var maxLengthHintView = { createMaxLengthHint() }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Инициализирует стек с делегатом и плейсхолдером
    convenience init(delegate: UITextFieldDelegate, placeholder: String) {
        self.init(frame: .zero)
        habitNameTextField.delegate = delegate
        habitNameTextField.placeholder = placeholder
    }
    
    // MARK: - Public Methods
    
    /// Снимает фокус с текстового поля
    override func resignFirstResponder() -> Bool {
        habitNameTextField.resignFirstResponder()
    }
    
    /// Метод для подписки на событие editingChanged внутреннего textField
        func addTargetForEditingChanged(_ target: Any?, action: Selector) {
            habitNameTextField.addTarget(target, action: action, for: .editingChanged)
        }
}

// MARK: - Private Methods

private extension HabitNameInputView {
    func setupView() {
        backgroundColor = .ypWhiteDay
        axis = .vertical
        spacing = 0
        addArrangedSubview(habitNameTextField)
        addArrangedSubview(maxLengthHintView)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            habitNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            habitNameTextField.topAnchor.constraint(equalTo: topAnchor),
            habitNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            habitNameTextField.heightAnchor.constraint(equalToConstant: 80),
            
            maxLengthHintView.leadingAnchor.constraint(equalTo: leadingAnchor),
            maxLengthHintView.topAnchor.constraint(equalTo: habitNameTextField.bottomAnchor),
            maxLengthHintView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        maxLengthHintView.isHidden = shouldHideMaxLengthHint
    }
    
    func createTextField() -> TrackerNameInputTextField {
        let textField = TrackerNameInputTextField()
        textField.placeholder = "Назови свою привычку"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    func createMaxLengthHint() -> HabitNameInputFooterView {
        HabitNameInputFooterView()
    }
}

// MARK: - Class Definition

/// Кастомное текстовое поле для ввода названия привычки
final class TrackerNameInputTextField: UITextField {
    
    // MARK: - Private Properties
    
    private let textPadding = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 41)
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPadding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPadding)
    }
    
    // MARK: - Private Methods
    
    private func setupAppearance() {
        layer.cornerRadius = 16
        layer.masksToBounds = true
        backgroundColor = .ypBackgroundDay
        clearButtonMode = .whileEditing
        textColor = .ypBlackDay
        font = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
}
