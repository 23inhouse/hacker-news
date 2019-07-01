//
//  IntTests.swift
//  HackerNewsTests
//
//  Created by Benjamin Lewis on 1/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest
@testable import HackerNews

class IntTests: XCTestCase {
    func testOf() {
        XCTAssertEqual(0.of("minute"), "0 minutes", "Wrong message")
        XCTAssertEqual(1.of("minute"), "1 minute", "Wrong message")
        XCTAssertEqual(2.of("minute"), "2 minutes", "Wrong message")
    }
}
