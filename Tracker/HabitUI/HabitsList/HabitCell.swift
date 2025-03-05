//
//  HabitCell.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Protocol

protocol TrackerViewCellProtocol: AnyObject {
    func trackerDoneButtonDidTapped(for trackerID: UUID)
    func trackerCounterValue(for trackerID: UUID) -> Int
}

// MARK: - Class Definition

/// Ячейка коллекции для отображения привычки
final class HabitViewCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    
    static let cellIdentifier = "habitCell"
    static let quantityCardHeight = CGFloat(58)
    
    // MARK: - Public Properties
    
    weak var delegate: TrackerViewCellProtocol?
    var trackerID: UUID?
    
    var cellColor: UIColor? {
        didSet {
            trackerView.backgroundColor = cellColor
            doneButton.backgroundColor = cellColor
        }
    }
    
    var cellName: String? {
        didSet {
            cellNameLabel.text = cellName
        }
    }
    
    var emoji: String? {
        didSet {
            emojiLabel.text = emoji
        }
    }
    
    var pinned: Bool = false {
        didSet {
            pinnedImageView.image = pinned ? pinImage : UIImage()
        }
    }
    
    var quantity: Int? {
        didSet {
            guard let quantity else {
                quantityLabel.text = ""
                return
            }
            let daysText = StringUtilities.getDaysText(for: quantity)
            quantityLabel.text = "\(quantity) \(daysText)"
        }
    }
    
    var isCompleted: Bool? {
        didSet {
            configureDoneButton()
        }
    }
    
    var isDoneButtonEnabled: Bool? {
        didSet {
            doneButton.alpha = (isDoneButtonEnabled == true) ? 1 : 0.3
        }
    }
    
    // MARK: - Private Properties
    
    private let pinImage = UIImage(systemName: "pin.fill") ?? UIImage()
    private let fontSize = CGFloat(12)
    private let buttonRadius = CGFloat(17)
    private var buttonLabelText: String { (isCompleted == true) ? "✓" : "＋" }
    
    private lazy var trackerView = { createTrackerView() }()
    private lazy var cellNameLabel = { createNameLabel() }()
    private lazy var emojiLabel = { createEmojiLabel() }()
    private lazy var pinnedImageView = { createPinnedImageView() }()
    private lazy var quantityLabel = { createCounterLabel() }()
    private lazy var doneButton = { createDoneButton() }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func doneButtonDidTap() {
        guard let trackerID else {
            assertionFailure("Не удалось определить ID трекера")
            return
        }
        guard isDoneButtonEnabled == true else { return }
        
        isCompleted = !(isCompleted ?? false)
        delegate?.trackerDoneButtonDidTapped(for: trackerID)
        quantity = delegate?.trackerCounterValue(for: trackerID)
    }
    
    // MARK: - Private Methods
    
    private func createTrackerView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cellNameLabel)
        view.addSubview(emojiLabel)
        view.addSubview(pinnedImageView)
        return view
    }
    
    private func createNameLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 2
        label.contentMode = .bottomLeft
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createEmojiLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        label.textAlignment = .center
        label.contentMode = .center
        label.backgroundColor = .white.withAlphaComponent(0.3)
        label.numberOfLines = 1
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createPinnedImageView() -> UIImageView {
        let imageView = UIImageView(image: UIImage())
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func createCounterLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createDoneButton() -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = buttonRadius
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.titleLabel?.textAlignment = .center
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneButtonDidTap), for: .touchUpInside)
        return button
    }
    
    private func configureDoneButton() {
        doneButton.setTitle(buttonLabelText, for: .normal)
    }
    
    private func addSubviews() {
        let quantityView = UIView()
        quantityView.translatesAutoresizingMaskIntoConstraints = false
        quantityView.addSubview(quantityLabel)
        quantityView.addSubview(doneButton)
        
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.addArrangedSubview(trackerView)
        vStackView.addArrangedSubview(quantityView)
        contentView.addSubview(vStackView)
        
        NSLayoutConstraint.activate([
            vStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            vStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            quantityView.heightAnchor.constraint(equalToConstant: Self.quantityCardHeight),
            quantityLabel.leadingAnchor.constraint(equalTo: quantityView.leadingAnchor, constant: 12),
            quantityLabel.topAnchor.constraint(equalTo: quantityView.topAnchor, constant: 16),
            quantityLabel.heightAnchor.constraint(equalToConstant: fontSize),
            quantityLabel.trailingAnchor.constraint(lessThanOrEqualTo: doneButton.leadingAnchor, constant: -8),
            
            doneButton.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: buttonRadius * 2),
            doneButton.heightAnchor.constraint(equalTo: doneButton.widthAnchor),
            doneButton.trailingAnchor.constraint(equalTo: quantityView.trailingAnchor, constant: -12),
            
            emojiLabel.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            
            pinnedImageView.heightAnchor.constraint(equalToConstant: 24),
            pinnedImageView.widthAnchor.constraint(equalTo: pinnedImageView.heightAnchor),
            emojiLabel.heightAnchor.constraint(equalTo: pinnedImageView.heightAnchor),
            
            pinnedImageView.centerYAnchor.constraint(equalTo: emojiLabel.centerYAnchor),
            pinnedImageView.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -12),
            
            cellNameLabel.topAnchor.constraint(greaterThanOrEqualTo: emojiLabel.bottomAnchor, constant: 8),
            cellNameLabel.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            cellNameLabel.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -12),
            cellNameLabel.bottomAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: -12)
        ])
    }
}
