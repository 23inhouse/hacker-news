//
//  NewsItemViewCellTests.swift
//  HackerNewsTests
//
//  Created by Benjamin Lewis on 27/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest
@testable import HackerNews

class NewsItemViewCellTests: XCTestCase {
    func testTitle() {
        let cell = NewsItemViewCell()
        XCTAssertEqual(cell.title.numberOfLines, 2, "Wrong number of lines")
    }

    func testTitleSetContent() {
        let cell = NewsItemViewCell()
        cell.titleText = "Does your lorem ipsum text long for something a little meatier? Give our generator a try… it’s tasty!"
        XCTAssertEqual(cell.title.textContent, cell.titleText, "Wrong text content")
    }

    func testComment() {
        let cell = NewsItemViewCell()
        XCTAssertEqual(cell.comment.numberOfLines, 1, "Wrong number of lines")
    }

    func testCommentSetContent() {
        let cell = NewsItemViewCell()
        cell.commentText = "Does your lorem ipsum text long for something a little meatier? Give our generator a try… it’s tasty!"
        XCTAssertEqual(cell.comment.textContent, cell.commentText, "Wrong text content")
    }
}
