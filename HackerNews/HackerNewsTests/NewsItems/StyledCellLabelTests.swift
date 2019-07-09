//
//  StyledCellLabelTests.swift
//  HackerNewsTests
//
//  Created by Benjamin Lewis on 28/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest
@testable import HackerNews

class StyledCellLabelTests: XCTestCase {
    func testNullState() {
        let label = StyledCellLabel()
        XCTAssertEqual(label.text, " ", "The text should be ' '")
        XCTAssertEqual(label.attributedText?.string, " ")
        XCTAssertEqual(label.accessibilityLabel, " ", "The accessibilityLabel should be ' '")
        XCTAssertEqual(label.backgroundColor, #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1), "Wrong background color")
    }

    func testSettingTextContent() {
        let label = StyledCellLabel()
        label.textContent = "Does your lorem ipsum ..."
        XCTAssertEqual(label.text, "Does your lorem ipsum ...", "The text should be 'Does your lorem ipsum ...'")
        XCTAssertEqual(label.attributedText?.string, "Does your lorem ipsum ...", "The attributed text should be 'Does your lorem ipsum ...'")
        XCTAssertEqual(label.accessibilityLabel, "Does your lorem ipsum ...", "The accessibiblity label should be 'Does your lorem ipsum ...'")
        XCTAssertEqual(label.backgroundColor, .white, "Wrong background color")
    }

    func testSettingAttributedContent() {
        let label = StyledCellLabel()
        label.attributedContent = NSAttributedString(string: "Does your lorem ipsum ...")
        XCTAssertEqual(label.text, "Does your lorem ipsum ...", "The text should be 'Does your lorem ipsum ...'")
        XCTAssertEqual(label.attributedText, NSAttributedString(string: "Does your lorem ipsum ..."), "The attributed text should be 'Does your lorem ipsum ...'")
        XCTAssertEqual(label.accessibilityLabel, "Does your lorem ipsum ...", "The accessibiblity label should be 'Does your lorem ipsum ...'")
        XCTAssertEqual(label.backgroundColor, .white, "Wrong background color")
    }
}
