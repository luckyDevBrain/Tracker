//
//  StatisticsStorageProtocol.swift
//  Tracker
//
//  Created by Kirill on 13.04.2025.
//

import Foundation

protocol StatisticsStorageProtocol {
    func getBestPeriod() -> Int
    func getPerfectDays() -> Int
    func getAverageCompleted() -> Int
    func getTrackersCompleted() -> Int
    func increaseTrackersCompleted()
    func decreaseTrackersCompleted()
}
