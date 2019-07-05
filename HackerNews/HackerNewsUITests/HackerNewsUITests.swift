//
//  HackerNewsUITests.swift
//  HackerNewsUITests
//
//  Created by Benjamin Lewis on 27/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest

class HackerNewsUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launchArguments = ["-firebaseTest"]
    }

    func testMainView() {
        app.launch()

        XCTAssertEqual(app.staticTexts.count, 12, "Wrong number of labels")

        XCTAssertStaticText("title", with: "How AMD Gave China the 'Keys to the Kingdom'")
        XCTAssertStaticText("comment count", with: "108 Comments")
    }

    func testSearch() {
        app.launch()

        XCTAssertEqual(app.staticTexts.count, 12, "Wrong number of labels")

        let search = app.searchFields.element
        XCTAssertTrue(search.exists, "Element search doesn't exist")
        XCTAssertEqual(search.label, "Search...", "Wrong search description")

        search.tap()
        search.typeText("space station")

        XCTAssertStaticText("searched title") {
            "The International Space Station is growing mold, inside and outside"
        }
        XCTAssertStaticText("searched comment count", with: "66 Comments")

        search.buttons.element.tap()
        search.typeText("space")
        XCTAssertEqual(app.staticTexts.count, 4, "Wrong number of labels")

        search.buttons.element.tap()
        search.typeText("the to")
        XCTAssertEqual(app.staticTexts.count, 4, "Wrong number of labels")

        search.buttons.element.tap()
        search.typeText("000")
        XCTAssertEqual(app.staticTexts.count, 0, "Wrong number of labels")

        search.buttons.element.tap()
        search.typeText("Gave China")
        XCTAssertEqual(app.staticTexts.count, 2, "Wrong number of labels")

        let title = XCTAssertStaticText("title", with: "How AMD Gave China the 'Keys to the Kingdom'")
        title.tap()

        XCTAssertFalse(app.searchFields.element.exists, "Element search shouldn't be visible")

        app.buttons["Back"].firstMatch.tap()

        XCTAssertTrue(app.searchFields.element.exists, "Element search should be visible")
    }

    func testComments() {
        app.launch()

        let title = XCTAssertStaticText("title", with: "How AMD Gave China the 'Keys to the Kingdom'")
        title.tap()

        sleep(1)

        let username = XCTAssertStaticText("username", with: "simonh")
        XCTAssertStaticText("time since", with: "11 hours ago")

        XCTAssertStaticText("title", with: "How AMD Gave China the 'Keys to the Kingdom'")
        XCTAssertStaticText("comment count", with: "108 Comments")

        XCTAssertStaticText("username", with: "bifel")
        XCTAssertStaticText("time since", with: "30 minutes ago")
        XCTAssertStaticText("comment body") {
            """
            Wouldn't putting "everyone in a numbered sequence unknown to them" require a random number, which we don't have?
            """
        }

        XCTAssertEqual(app.staticTexts.count, 14, "Wrong number of labels")
        username.tap()

        var textCount = 0
        for index in 0 ..< app.staticTexts.count {
            if app.staticTexts.element(boundBy: index).isHittable {
                textCount += 1
            }
        }
        XCTAssertEqual(textCount, 7, "Wrong number of labels")
    }

    @discardableResult
    func XCTAssertStaticText(_ type: String, with label: String, file: StaticString = #file, line: UInt = #line) -> XCUIElement {
        let staticTextElement = XCUIApplication().staticTexts[label].firstMatch

        let existenceErrorMessage = "Can't find [\(type)] with [\(label)]"
        XCTAssertTrue(staticTextElement.exists, existenceErrorMessage, file: file, line: line)
        let labelErrorMessage = "Wrong content in [\(type)]\n\nExpected: [\(label)]\n\nFound: [\(staticTextElement.label)]"
        XCTAssertEqual(staticTextElement.label, label, labelErrorMessage, file: file, line: line)

        return staticTextElement
    }

    @discardableResult
    func XCTAssertStaticText(_ type: String, file: StaticString = #file, line: UInt = #line, contentClosure: () -> String) -> XCUIElement {

        let label = contentClosure()
        return XCTAssertStaticText(type, with: label, file: file, line: line)
    }
}
