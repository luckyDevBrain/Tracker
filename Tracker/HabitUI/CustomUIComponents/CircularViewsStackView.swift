//
//  CircularViewsStackView.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Class Definition

/// Стек с видами, имеющими скругленные углы в зависимости от позиции
final class CircularViewsStackView: UIStackView {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Инициализирует стек с заданными подвидами и применяет стили скругления
    convenience init(arrangedSubviews: [StackCircularView]) {
        self.init(frame: .zero)
        axis = .vertical
        alignment = .fill
        distribution = .equalSpacing
        setupCircularStyles(for: arrangedSubviews)
    }
    
    // MARK: - Private Methods
    
    private func setupCircularStyles(for subviews: [StackCircularView]) {
        guard !subviews.isEmpty else { return }
        
        if subviews.count == 1 {
            subviews[0].circularCornerStyle = .topAndBottom
        } else {
            for (index, subview) in subviews.enumerated() {
                switch index {
                case 0:
                    subview.circularCornerStyle = .topOnly
                case subviews.count - 1:
                    subview.circularCornerStyle = .bottomOnly
                default:
                    subview.circularCornerStyle = .notCircular
                }
            }
        }
        
        subviews.forEach { addArrangedSubview($0) }
    }
}
