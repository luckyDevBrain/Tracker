//
//  HabitsSectionHeaderView.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

final class TrackersSectionHeaderView: UICollectionReusableView {
    static let viewIdentifier = "trackresSectionHeader"

    let headerLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        headerLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            headerLabel.topAnchor.constraint(equalTo: topAnchor)
        ])

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
