//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Kirill on 24.03.2025.
//

import UIKit

// MARK: - Class Definition

/// Ячейка для отображения эмодзи в коллекции
final class EmojiCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = "emoji"
    
    // MARK: - Public Properties
    
    var emoji: String? {
        didSet {
            guard let emoji else { return }
            emojiLabel.text = emoji
        }
    }
    
    override var isSelected: Bool {
        didSet {
            applyStyle(for: isSelected)
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var emojiLabel = { createEmojiLabel() }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(emojiLabel)
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func createEmojiLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func applyStyle(for isSelectedState: Bool) {
        contentView.backgroundColor = isSelectedState ? .ypBackgroundDay.withAlphaComponent(1) : .ypWhiteDay
    }
}

// MARK: - Extensions

// MARK: - PropertyCellProtocol
extension EmojiCollectionViewCell: PropertyCellProtocol {
    func config(with emoji: String) {
        self.emoji = emoji
    }
}
