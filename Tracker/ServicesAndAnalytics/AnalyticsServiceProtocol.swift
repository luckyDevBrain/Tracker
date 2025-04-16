//
//  AnalyticsServiceProtocol.swift
//  Tracker
//
//  Created by Kirill on 13.04.2025.
//

protocol AnalyticsServiceProtocol {
    func report(
        event eventType: AnalyticsEventType,
        screen screenType: AnalyticsScreenType,
        item itemType: AnalyticsItemType?
    )
}

enum AnalyticsEventType: String {
    case open, close, click
}

enum AnalyticsScreenType: String {
    case Main
}

enum AnalyticsItemType: String {
    case track, filter, edit, delete
    case addTrack = "add_track"
}
