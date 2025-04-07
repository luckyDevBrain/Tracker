//
//  ColorExtensions.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

extension UIColor {
    static let ypBackgroundDayCode = UIColor(named: "ypBackgroundDay")!
    static let ypBlackDayCode = UIColor(named: "ypBlackDay")!
    static let ypBlueCode = UIColor(named: "ypBlue")!
    static let ypGrayCode = UIColor(named: "ypGray")!
    static let ypRedCode = UIColor(named: "ypRed")!
    static let ypWhiteDayCode = UIColor(named: "ypWhiteDay")!

    enum YpColors: String, CaseIterable {
        case ypColorSelectionCode1 = "ypColorSelection-1"
        case ypColorSelectionCode2 = "ypColorSelection-2"
        case ypColorSelectionCode3 =  "ypColorSelection-3"
        case ypColorSelectionCode4 =  "ypColorSelection-4"
        case ypColorSelectionCode5 =  "ypColorSelection-5"
        case ypColorSelectionCode6 =  "ypColorSelection-6"
        case ypColorSelectionCode7 =  "ypColorSelection-7"
        case ypColorSelectionCode8 =  "ypColorSelection-8"
        case ypColorSelectionCode9 =  "ypColorSelection-9"
        case ypColorSelectionCode10 = "ypColorSelection-10"
        case ypColorSelectionCode11 = "ypColorSelection-11"
        case ypColorSelectionCode12 = "ypColorSelection-12"
        case ypColorSelectionCode13 = "ypColorSelection-13"
        case ypColorSelectionCode14 = "ypColorSelection-14"
        case ypColorSelectionCode15 = "ypColorSelection-15"
        case ypColorSelectionCode16 = "ypColorSelection-16"
        case ypColorSelectionCode17 = "ypColorSelection-17"
        case ypColorSelectionCode18 = "ypColorSelection-18"

        static func allColorNames() -> [String] {
            return allCases.compactMap{ $0.rawValue }
        }

        func color() -> UIColor? {
            return UIColor(named: self.rawValue)
        }
    }
}
