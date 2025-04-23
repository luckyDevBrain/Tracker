//
//  StatisticsViewModelProtocol.swift
//  Tracker
//
//  Created by Kirill on 13.04.2025.
//

struct StatisticsViewModelBindings {
    let bestPeriod: (Int) -> Void
    let perfectDays: (Int) -> Void
    let trackersCompleted: (Int) -> Void
    let averageCompleted: (Int) -> Void
    let isStatisticsPresenting: (Bool) -> Void
}

protocol StatisticsViewModelProtocol {
    func viewWillAppear()
    func setBindings(_ bindings: StatisticsViewModelBindings)
}
