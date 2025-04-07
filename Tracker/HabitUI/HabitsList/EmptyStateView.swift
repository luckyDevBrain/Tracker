//
//  EmptyStateView.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Enums

enum PlaceholderType {
    case noData
    case emptyList
}

// MARK: - Class Definition

final class EmptyStateView: UIView {
    
    // MARK: - Public Properties
    
    var placeholderType: PlaceholderType = .noData {
        didSet {
            updateUIForPlaceholderType()
        }
    }
    
    // MARK: - Private Properties
    
    private let circleStarImage = UIImage(named: "circleStar") ?? UIImage()
    private let monocleFaceImage = UIImage(named: "monocleFace") ?? UIImage()
    private let noDataText = "Что будем отслеживать?"
    private let emptyListText = "Ничего не найдено"
    
    private lazy var placeholderImage: UIImageView = {
        let imageView = UIImageView(image: circleStarImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderImage)
        addSubview(placeholderLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            placeholderImage.topAnchor.constraint(equalTo: topAnchor),
            placeholderImage.heightAnchor.constraint(equalToConstant: 80),
            placeholderImage.widthAnchor.constraint(equalToConstant: 80),
            placeholderImage.bottomAnchor.constraint(equalTo: placeholderLabel.topAnchor),
            placeholderImage.centerXAnchor.constraint(equalTo: placeholderLabel.centerXAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func updateUIForPlaceholderType() {
        switch placeholderType {
        case .noData:
            placeholderImage.image = circleStarImage
            placeholderLabel.text = noDataText
        case .emptyList:
            placeholderImage.image = monocleFaceImage
            placeholderLabel.text = emptyListText
        }
    }
}
