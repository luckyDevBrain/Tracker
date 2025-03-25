//
//  HabitNameInputView.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Class Definition

/// Представление для ввода названия трекера
final class HabitNameInputView: UIStackView {
    
    // MARK: - Public Properties
    
    var isMaxLengthHintHidden = true {
        didSet {
            maxLengthHintView.isHidden = isMaxLengthHintHidden
        }
    }
    
    var text: String {
        inputTextField.text ?? ""
    }
    
    weak var delegate: UITextFieldDelegate? {
        didSet {
            inputTextField.delegate = delegate
        }
    }
    
    override var isFirstResponder: Bool {
        get {
            return inputTextField.isFirstResponder
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var inputTextField = { createInputTextField() }()
    private lazy var maxLengthHintView = { createHintView() }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .ypWhiteDay
        axis = .vertical
        spacing = 0
        addArrangedSubview(inputTextField)
        addArrangedSubview(maxLengthHintView)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            inputTextField.topAnchor.constraint(equalTo: topAnchor),
            inputTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            inputTextField.heightAnchor.constraint(equalToConstant: 75),
            
            maxLengthHintView.leadingAnchor.constraint(equalTo: leadingAnchor),
            maxLengthHintView.topAnchor.constraint(equalTo: inputTextField.bottomAnchor),
            maxLengthHintView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        maxLengthHintView.isHidden = isMaxLengthHintHidden
    }
    
    convenience init(delegate: UITextFieldDelegate, placeholder: String) {
        self.init(frame: .zero)
        inputTextField.delegate = delegate
        inputTextField.placeholder = placeholder
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    override func resignFirstResponder() -> Bool {
        return inputTextField.resignFirstResponder()
    }
}

// MARK: - Extensions

// MARK: - Layout
private extension HabitNameInputView {
    func createInputTextField() -> NameInputTextField {
        let textField = NameInputTextField()
        textField.placeholder = "Введите название трекера"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    func createHintView() -> HabitNameInputFooterView {
        let hintView = HabitNameInputFooterView()
        return hintView
    }
}

// MARK: - Class Definition

/// Поле ввода для названия трекера с кастомными отступами
class NameInputTextField: UITextField {
    
    // MARK: - Private Properties
    
    private let insets = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 41)
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        layer.masksToBounds = true
        backgroundColor = .ypBackgroundDay
        clearButtonMode = .whileEditing
        textColor = .ypBlackDay
        font = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
}
