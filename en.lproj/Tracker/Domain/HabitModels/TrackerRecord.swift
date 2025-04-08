//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import Foundation

/// Структура для хранения записейе о выполненных событиях
struct TrackerRecord: Hashable {
    let trackerID: UUID
    /// Дата выполнения события
    let dateCompleted: Date
}
