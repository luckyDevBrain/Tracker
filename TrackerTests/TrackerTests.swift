//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Kirill on 15.10.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testStartViewController() throws {
        let startVC = StartViewController()
        // .light mode
        assertSnapshots(of: startVC, as: [.image(on: .iPhone13ProMax, traits: UITraitCollection(userInterfaceStyle: .light))])
        assertSnapshots(of: startVC, as: [.image(on: .iPhone13, traits: UITraitCollection(userInterfaceStyle: .light))])

        // .dark mode
        assertSnapshots(of: startVC, as: [.image(on: .iPhone13ProMax, traits: UITraitCollection(userInterfaceStyle: .dark))])
        assertSnapshots(of: startVC, as: [.image(on: .iPhone13, traits: UITraitCollection(userInterfaceStyle: .dark))])
    }
}
