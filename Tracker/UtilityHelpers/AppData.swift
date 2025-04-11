//
//  AppData.swift
//  Tracker
//
//  Created by Kirill on 08.04.2025.
//

import Foundation

class AppData {

    private enum AppDataKeys {
        static let didStartBefore = "didStartBefore"
    }

    static var isFirstAppStart: Bool {
        get {
            !UserDefaults.standard.bool(forKey: AppDataKeys.didStartBefore)
        }
        set {
            UserDefaults.standard.setValue(!newValue, forKey: AppDataKeys.didStartBefore)
        }
    }
}
