//
//  EmptyStateView.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

enum PlaceholderType {
    case noData, emptyList
}

final class EmptyCollectionPlaceholderView: PlaceholderView {

    var placeholderType: PlaceholderType = .noData {
        didSet {
            switch placeholderType {
            case .noData:
                placeholderImage = circleStarImage
                placeholderText = noDataText
            case .emptyList:
                placeholderImage = monocleFaceImage
                placeholderText = emptyListText
            }
        }
    }

    private let circleStarImage = UIImage(named: "circleStar") ?? UIImage()
    private let monocleFaceImage = UIImage(named: "monocleFace") ?? UIImage()
    private let noDataText = "Что будем отслеживать?"
    private let emptyListText = "Ничего не найдено"
}
