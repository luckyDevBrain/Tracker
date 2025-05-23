//
//  StatisticsStorage.swift
//  Tracker
//
//  Created by Kirill on 13.04.2025.
//

import Foundation

final class StatisticsStorage: StatisticsStorageProtocol {
    private var storage = AppData.shared

    func getBestPeriod() -> Int {
        storage.statisticsBestPeriod
    }

    func getPerfectDays() -> Int {
        storage.statisticsPerfectDays
    }

    func getTrackersCompleted() -> Int {
        storage.statisticsTrackersCount
    }

    func getAverageCompleted() -> Int {
        storage.statisticsAverageCompleted
    }

    func increaseTrackersCompleted() {
        storage.statisticsTrackersCount += 1
    }

    func decreaseTrackersCompleted() {
        storage.statisticsTrackersCount -= 1
    }
}
