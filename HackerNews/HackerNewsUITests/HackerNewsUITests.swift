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

        XCTAssertEqual(app.staticTexts.count, 12, "Wrong number of labels")

        let titleLabel = "How AMD Gave China the 'Keys to the Kingdom'"
        let title = app.staticTexts[titleLabel].firstMatch
        XCTAssertTrue(title.exists, "Element title doesn't exist")
        XCTAssertEqual(title.label, titleLabel, "Wrong text in title")

        let commentLabel = "108 Comments"
        let comment = app.staticTexts[commentLabel].firstMatch
        XCTAssertTrue(comment.exists, "Element comment doesn't exist")
        XCTAssertEqual(comment.label, commentLabel, "Wrong text in comment")
    }
}
