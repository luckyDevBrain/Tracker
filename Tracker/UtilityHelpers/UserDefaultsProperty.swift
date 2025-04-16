//
//  UserDefaultsProperty.swift
//  Tracker
//
//  Created by Kirill on 13.04.2025.
//

import Foundation

@propertyWrapper
final class UserDefaultsProperty {

    let storage = UserDefaults.standard
    var key: String
    var wrappedValue: Int {
        get {
            storage.integer(forKey: key)
        }
        set {
            storage.setValue(newValue, forKey: key)
        }
    }

    init(key: any RawRepresentable) {
        self.key = key.rawValue as? String ?? ""
    }
}
