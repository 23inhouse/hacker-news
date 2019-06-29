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

    func testSearch() {
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

        let search = app.searchFields.element
        XCTAssertTrue(search.exists, "Element search doesn't exist")
        XCTAssertEqual(search.label, "Search...", "Wrong search description")

        search.tap()
        search.typeText("space station")

        let searchedTitleLabel = "The International Space Station is growing mold, inside and outside"
        let searchedTitle = app.staticTexts[searchedTitleLabel].firstMatch
        XCTAssertTrue(searchedTitle.exists, "Element searched title doesn't exist")
        XCTAssertEqual(searchedTitle.label, searchedTitleLabel, "Wrong text in title")

        let searchedCommentLabel = "66 Comments"
        let searchedComment = app.staticTexts[searchedCommentLabel].firstMatch
        XCTAssertTrue(searchedComment.exists, "Element searched comment doesn't exist")
        XCTAssertEqual(searchedComment.label, searchedCommentLabel, "Wrong text in comment")

        search.buttons.element.tap()
        search.typeText("space")
        XCTAssertEqual(app.staticTexts.count, 4, "Wrong number of labels")

        search.buttons.element.tap()
        search.typeText("the to")
        XCTAssertEqual(app.staticTexts.count, 4, "Wrong number of labels")
    }
}
