//
//  HackerNewsUITests.swift
//  HackerNewsUITests
//
//  Created by Benjamin Lewis on 27/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest

class HackerNewsUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    func testExample() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertEqual(app.staticTexts.count, 6, "Wrong number of labels")
    }
}
