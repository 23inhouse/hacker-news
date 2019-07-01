//
//  DateTests.swift
//  HackerNewsTests
//
//  Created by Benjamin Lewis on 1/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest
@testable import HackerNews

class DateTests: XCTestCase {
    func testBackToTheFuture() {
        let date = Date(timeIntervalSinceNow: 1)
        XCTAssertEqual(Date.time(since: date), "Back to the future", "Wrong time ago")
    }

    func testTimeSinceSeconds() {
        let expectations: [(Int, String)] = [
            (3, "3 seconds ago"),
            (3 * 60, "3 minutes ago"),
            (3 * 60 * 60, "3 hours ago"),
            (3 * 60 * 60 * 24, "3 days ago"),
            (3 * 60 * 60 * 24 * 7, "3 weeks ago"),
            (3 * 60 * 60 * 24 * 31, "3 months ago"),
            (3 * 60 * 60 * 24 * 366, "3 years ago"),
        ]

        for expectation in expectations {
            let (seconds, expected) = expectation
            let date = Date(timeIntervalSinceNow: Double(-seconds))
            XCTAssertEqual(Date.time(since: date), expected, "Wrong time ago")
        }
    }
}
