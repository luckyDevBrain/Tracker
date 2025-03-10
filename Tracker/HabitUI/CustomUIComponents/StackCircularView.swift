//
//  StackCircularView.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Enums

/// Стили скругления углов для представления
enum CircularCornerStyle {
    case topOnly
    case bottomOnly
    case topAndBottom
    case notCircular
}

// MARK: - Class Definition

/// Представление с настраиваемыми углами и текстовыми метками
class StackCircularView: UIView {
    
    // MARK: - Public Properties
    
    /// Стиль скругления углов представления
    var circularCornerStyle: CircularCornerStyle? {
        didSet {
            updateCornerStyle(circularCornerStyle)
            separatorView.isHidden = [.topOnly, .topAndBottom].contains(circularCornerStyle)
        }
    }
    
    /// Основной текст представления
    var text: String = "" {
        didSet {
            buttonNameLabel.text = text
        }
    }
    
    /// Дополнительный текст (подробности)
    var detailedText: String? {
        didSet {
            updateDetailText(detailedText)
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var buttonNameLabel = { createNameLabel() }()
    private lazy var buttonDetailLabel = { createDetailLabel() }()
    private lazy var actionButton = { createActionStack() }()
    private lazy var separatorView = { createSeparatorView() }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        backgroundColor = .ypBackgroundDay
        addSubview(separatorView)
        addSubview(actionButton)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 75),
            
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -75),
            
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    private func createNameLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlackDay
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createDetailLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createActionStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [buttonNameLabel, buttonDetailLabel])
        stack.spacing = 2
        stack.alignment = .leading
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    private func createSeparatorView() -> UIView {
        let view = UIView()
        view.layer.borderColor = UIColor.ypGray.cgColor
        view.layer.borderWidth = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func updateDetailText(_ text: String?) {
        guard let text, !text.isEmpty else {
            buttonDetailLabel.isHidden = true
            return
        }
        buttonDetailLabel.isHidden = false
        buttonDetailLabel.text = text
    }
    
    private func updateCornerStyle(_ style: CircularCornerStyle?) {
        layer.cornerRadius = 16
        layer.masksToBounds = true
        switch style {
        case .topOnly:
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .bottomOnly:
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .topAndBottom:
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        default:
            layer.cornerRadius = 0
            layer.masksToBounds = false
        }
    }
}
