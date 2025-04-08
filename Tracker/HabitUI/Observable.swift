//
//  Observable.swift
//  Tracker
//
//  Created by Kirill on 08.04.2025.
//

import Foundation

@propertyWrapper
final class Observable<Value> {
    private var onChange: ((Value) -> Void)?

    var wrappedValue: Value {
        didSet {
            onChange?(wrappedValue)
        }
    }

    var projectedValue: Observable<Value> {
        return self
    }

    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    func bind(action: @escaping (Value) -> Void) {
        self.onChange = action
    }
}
