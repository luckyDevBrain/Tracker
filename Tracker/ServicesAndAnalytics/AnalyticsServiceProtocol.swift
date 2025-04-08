//
//  AnalyticsServiceProtocol.swift
//  Tracker
//
//  Created by Kirill on 08.04.2025.
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
    case main
}

enum AnalyticsItemType: String {
    case track, filter, edit, delete
    case addTrack = "add_track"
}
