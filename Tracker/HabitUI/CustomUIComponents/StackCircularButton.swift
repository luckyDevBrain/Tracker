//
//  StackCircularButton.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Class Definition

/// Представление с круглыми углами и шевроном для навигации
final class StackCircularButton: StackCircularView {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChevron()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Инициализирует кнопку с обработчиком нажатий
    convenience init(target: Any?, action: Selector) {
        self.init(frame: .zero)
        configureTapGesture(target: target, action: action)
    }
    
    // MARK: - Private Methods
    
    private func setupChevron() {
        let chevronView = createChevronView()
        addSubview(chevronView)
        
        NSLayoutConstraint.activate([
            chevronView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func createChevronView() -> UIView {
        let chevronImage = UIImage(systemName: "chevron.right") ?? UIImage()
        let chevronView = UIImageView(image: chevronImage)
        chevronView.contentMode = .center
        chevronView.tintColor = .ypGray
        chevronView.translatesAutoresizingMaskIntoConstraints = false
        return chevronView
    }
    
    private func configureTapGesture(target: Any?, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(tapGesture)
    }
}
