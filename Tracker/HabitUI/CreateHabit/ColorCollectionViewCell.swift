//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Kirill on 24.03.2025.
//

import UIKit

// MARK: - Class Definition

/// Ячейка для отображения цвета в коллекции
final class ColorCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = "color"
    
    // MARK: - Public Properties
    
    var color: UIColor? {
        didSet {
            applyStyle(for: (color == nil ? false : isSelected))
        }
    }
    
    override var isSelected: Bool {
        didSet {
            applyStyle(for: (color == nil ? false : isSelected))
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 9.5
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = color == nil ? UIColor.clear.cgColor : color!.cgColor
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func applyStyle(for isSelectedState: Bool) {
        guard let color else { return }
        
        colorView.backgroundColor = color
        
        contentView.layer.borderColor = isSelectedState
            ? color.withAlphaComponent(0.3).cgColor
            : UIColor.clear.cgColor
    }
}

// MARK: - Extensions

// MARK: - PropertyCellProtocol
extension ColorCollectionViewCell: PropertyCellProtocol {
    func setCellSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
    }
    
    func config(with colorName: String) {
        guard let ypColor = UIColor.YpColors(rawValue: colorName) else { return }
        self.color = ypColor.color()
    }
}
