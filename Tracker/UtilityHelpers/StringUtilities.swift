//
//  StringUtilities.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import Foundation

extension String {
    func localized(comment: String = "") -> String {
        let localizedString = NSLocalizedString(self, comment: comment)
        return localizedString
    }

    func localizedValue(_ value: CVarArg, comment: String = "") -> String {
        String.localizedStringWithFormat(
            NSLocalizedString(self, comment: comment),
            value
        )
    }
}
