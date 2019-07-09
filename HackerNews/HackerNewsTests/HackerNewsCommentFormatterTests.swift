//
//  HackerNewsCommentFormatterTests.swift
//  HackerNewsTests
//
//  Created by Benjamin Lewis on 6/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest
@testable import HackerNews

class HackerNewsCommentFormatterTests: XCTestCase {
    func testCall() {
        let htmlText = "<p>text</p>"
        let attributedText = HackerNewsCommentFormatter.call(htmlText)

        let expectText = "text"
        XCTAssertEqual(attributedText.string, expectText, "Wrong formatted text")
    }

    func testCallWithParagraphs() {
        let htmlText = "<p>text</p><p>text</p>"
        let attributedText = HackerNewsCommentFormatter.call(htmlText)
        let attributedString = String(describing: attributedText)
        let paragraphStlyes = attributedString.split(separator: " ").filter({$0 == "NSParagraphStyle"})

        let expectText = "text\ntext"
        XCTAssertEqual(attributedText.string, expectText, "Wrong formatted text")
        XCTAssertEqual(paragraphStlyes.count, 2, "Wrong number of paragraphs")
    }

    func testCallWithItalic() {
        let htmlText = "&gt; My C&#x2F;C++ code is as boring as possible."
        let attributedText = HackerNewsCommentFormatter.call(htmlText)
        let attributedString = String(describing: attributedText)

        let expectText = "> My C/C++ code is as boring as possible."
        XCTAssertEqual(attributedText.string, expectText, "Wrong formatted text")
        XCTAssertNotNil(attributedString.range(of: "font-style: italic;"), "Didn't find the font style italic")
    }
}
