//
//  EmptyStateView.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Enums

/// Типы пустого состояния для отображения
enum PlaceholderType {
    case noData
    case emptyList
}

// MARK: - Class Definition

/// Представление для отображения пустого состояния с изображением и текстом
final class EmptyStateView: UIView {

    // MARK: - Public Properties

    /// Тип пустого состояния, определяющий отображаемые изображение и текст
    var placeholderType: PlaceholderType = .noData {
        didSet {
            updatePlaceholderContent()
        }
    }

    // MARK: - Private Properties

    private let circleStarImage = UIImage(named: "circleStar") ?? UIImage()
    private let monocleFaceImage = UIImage(named: "monocleFace") ?? UIImage()
    private let noDataText = "Что будем отслеживать?"
    private let emptyListText = "Ничего не найдено"

    private lazy var stateImageView = { createStateImageView() }()
    private lazy var stateLabel = { createStateLabel() }()

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
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stateImageView)
        addSubview(stateLabel)

        NSLayoutConstraint.activate([
            stateImageView.topAnchor.constraint(equalTo: topAnchor),
            stateImageView.heightAnchor.constraint(equalToConstant: 80),
            stateImageView.widthAnchor.constraint(equalToConstant: 80),
            stateImageView.bottomAnchor.constraint(equalTo: stateLabel.topAnchor),
            stateImageView.centerXAnchor.constraint(equalTo: stateLabel.centerXAnchor),

            stateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            stateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            stateLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        updatePlaceholderContent()
    }

    private func createStateImageView() -> UIImageView {
        let imageView = UIImageView(image: circleStarImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    private func createStateLabel() -> UILabel {
        let label = UILabel()
        label.text = noDataText
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func updatePlaceholderContent() {
        switch placeholderType {
        case .noData:
            stateImageView.image = circleStarImage
            stateLabel.text = noDataText
        case .emptyList:
            stateImageView.image = monocleFaceImage
            stateLabel.text = emptyListText
        }
    }
}
