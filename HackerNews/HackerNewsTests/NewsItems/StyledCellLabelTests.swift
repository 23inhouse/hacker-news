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
        XCTAssertEqual(label.accessibilityLabel, " ", "The accessibilityLabel should be ' '")
        XCTAssertEqual(label.backgroundColor, #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1), "Wrong background color")
    }

    func testSettingTextContent() {
        let label = StyledCellLabel()
        label.textContent = "Does your lorem ipsum text long for something a little meatier? Give our generator a try… it’s tasty!"
        XCTAssertEqual(label.text, "Does your lorem ipsum text long for something a little meatier? Give our generator a try… it’s tasty!", "The text should be ' '")
        XCTAssertEqual(label.accessibilityLabel, "Does your lorem ipsum text long for something a little meatier? Give our generator a try… it’s tasty!", "The accessibiblity label should be ' '")
        XCTAssertEqual(label.backgroundColor, .white, "Wrong background color")
    }
}
