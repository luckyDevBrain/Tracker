//
//  ObservableBox.swift
//  Tracker
//
//  Created by Kirill on 08.04.2025.
//

import Foundation

final class ObservableBox<T> {
    private var listener: ((T) -> Void)?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(_ listener: @escaping (T) -> Void) {
        self.listener = listener
        listener(value) // сразу вызываем, чтобы обновить UI
    }
}
