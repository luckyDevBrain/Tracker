//
//  HabitCell.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

protocol TrackerViewCellProtocol: AnyObject {
    func trackerDoneButtonDidSwitched(to isCompleted: Bool, for trackerID: UUID)
}

final class TrackerViewCell: UICollectionViewCell {
    static let cellIdentifier = "trackerCell"
    static let quantityCardHeight = CGFloat(58)

    weak var delegate: TrackerViewCellProtocol?
    var tracker: Tracker? {
        didSet {
            guard let tracker else { return }
            cellName = tracker.name
            cellColor = tracker.color?.color() ?? .clear
            emoji = tracker.emoji
            quantity = tracker.completedCounter
            isCompleted = tracker.isCompleted
            isPinned = tracker.isPinned
        }
    }

    var quantity: Int? {
        didSet {
            guard let quantity
            else {
                quantityLabel.text = ""
                return
            }
            let daysText = "numberOfDays".localizedValue(
                quantity,
                comment: "Number of days the tracker was completed"
            )
            quantityLabel.text = "\(quantity) \(daysText)"
        }
    }

    var isCompleted: Bool? {
        didSet {
            doneButton.setTitle((isCompleted == true) ? "✓" : "＋", for: .normal)
        }
    }

    var isDoneButtonEnabled: Bool? {
        didSet {
            // осознанно реализовал более привычную версию UI:
            // - недоступные кнопки (и только они) приглушаются цветом
            // - для выполненных/невыполненных меняется только title
            doneButton.alpha = (isDoneButtonEnabled == true) ? 1 : 0.3
        }
    }

    private var cellColor: UIColor? {
        didSet {
            trackerView.backgroundColor = cellColor
            doneButton.backgroundColor = cellColor
        }
    }
    private var cellName: String? {
        didSet {
            cellNameLabel.text = cellName
        }
    }
    private var emoji: String? {
        didSet {
            emojiLabel.text = emoji
        }
    }
    private var isPinned: Bool = false {
        didSet {
            pinnedImageView.image = isPinned ? pinImage : UIImage()
        }
    }

    private let pinImage = UIImage(systemName: "pin.fill") ?? UIImage()
    private let fontSize = CGFloat(12)
    private let buttonRadius = CGFloat(17)
    private var buttonLabelText: String { (isCompleted == true) ? "✓" : "＋" }

    private lazy var trackerView = { createTrackerView() }()
    private lazy var cellNameLabel = { createNameLabel() }()
    private lazy var emojiLabel = { createEmojiLabel() }()
    private lazy var pinnedImageView = { createPinnedImagedView() }()
    private lazy var quantityLabel = { createCounterLabel() }()
    private lazy var doneButton = { createDoneButton() }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getTrackerView() -> UIView {
        return trackerView
    }

    @objc private func doneButtonDidTap() {
        guard let trackerID = tracker?.trackerID else {
            assertionFailure("Не удалось определить ID трекера")
            return
        }

        if !(isDoneButtonEnabled == true) { return }

        let isButtonChecked = !(isCompleted ?? false)
        delegate?.trackerDoneButtonDidSwitched(to: isButtonChecked, for: trackerID)
    }
}

// MARK: Layout
private extension TrackerViewCell {
    func createTrackerView() -> UIView {
        let trackerView = UIView()
        trackerView.layer.cornerRadius = 16
        trackerView.layer.masksToBounds = true
        trackerView.translatesAutoresizingMaskIntoConstraints = false

        trackerView.addSubview(cellNameLabel)
        trackerView.addSubview(emojiLabel)
        trackerView.addSubview(pinnedImageView)
        return trackerView
    }

    func createNameLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 2
        label.contentMode = .bottomLeft
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func createEmojiLabel() -> UILabel {
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

    func createPinnedImagedView() -> UIImageView {
        let pinImage = UIImage()
        let imageView = UIImageView(image: pinImage)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    func createCounterLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        label.tintColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func createDoneButton() -> UIButton {
        let button = UIButton()

        button.layer.cornerRadius = buttonRadius
        button.layer.masksToBounds = true

        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.contentMode = .center
        button.tintColor = .white

        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneButtonDidTap), for: .touchUpInside)
        return button
    }

    func addSubviews() {
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
            doneButton.widthAnchor.constraint(equalToConstant: buttonRadius*2),
            doneButton.heightAnchor.constraint(equalTo: doneButton.widthAnchor),
            doneButton.trailingAnchor.constraint(equalTo: quantityView.trailingAnchor, constant: -12),

            emojiLabel.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalTo: emojiLabel.widthAnchor),

            pinnedImageView.heightAnchor.constraint(equalToConstant: 14),
            pinnedImageView.widthAnchor.constraint(equalTo: pinnedImageView.heightAnchor),

            pinnedImageView.centerYAnchor.constraint(equalTo: emojiLabel.centerYAnchor),
            pinnedImageView.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -22),

            cellNameLabel.topAnchor.constraint(greaterThanOrEqualTo: emojiLabel.bottomAnchor, constant: 8),
            cellNameLabel.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            cellNameLabel.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -12),
            cellNameLabel.bottomAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: -12)
        ])
    }
}
