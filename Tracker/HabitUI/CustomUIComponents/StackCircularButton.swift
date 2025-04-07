//
//  StackCircularButton.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

final class StackRoundedButton: StackRoundedView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        let accessoryView = createAccessoryView()
        addSubview(accessoryView)

        NSLayoutConstraint.activate([
            accessoryView.centerYAnchor.constraint(equalTo: centerYAnchor),
            accessoryView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(target: Any?, action: Selector) {
        self.init(frame: .zero)
        let tapGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(tapGestureRecognizer)
    }

    private func createAccessoryView() -> UIView {
        let accessoryImage = UIImage(systemName: "chevron.right") ?? UIImage()
        let accessoryView = UIImageView(image: accessoryImage)
        accessoryView.contentMode = .center
        accessoryView.translatesAutoresizingMaskIntoConstraints = false
        accessoryView.tintColor = .ypGray
        return accessoryView
    }
}
