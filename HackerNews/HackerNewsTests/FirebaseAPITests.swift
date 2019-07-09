//
//  FirebaseAPITests.swift
//  HackerNewsTests
//
//  Created by Benjamin Lewis on 6/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest
@testable import HackerNews

class MockNewsController: Requestable {
    var newsItemCount = 0
    var commentCounts = [Int: Int]()

    func setData(_ data: [Datable]) {
        newsItemCount = data.count
    }

    func setData(at index: Int, with data: Datable) {
        let data = data as! HackerNewsItem
        commentCounts[index] = data.commentCount
    }
}

class MockCommentsController: Requestable {
    var authors = [String]()

    func setData(_ data: [Datable]) {
        print("setData")
        data.forEach { data in
            let data = data as! HackerNewsFirebaseComment
            authors.append(data.author)
        }
    }

    func setData(at index: Int, with data: Datable) { }
}

class FirebaseAPITests: XCTestCase {
    func testCall() {
        let requestable = MockNewsController()
        let api = FirebaseAPI(requestable, TestFirebaseQuery(async: false))

        api.call()
        XCTAssertEqual(requestable.commentCounts[0], 55, "Wrong number of comments")
        XCTAssertEqual(requestable.commentCounts[1], 171, "Wrong number of comments")
        XCTAssertEqual(requestable.commentCounts[2], 108, "Wrong number of comments")
        XCTAssertEqual(requestable.commentCounts[3], 66, "Wrong number of comments")
        XCTAssertEqual(requestable.commentCounts[4], 0, "Wrong number of comments")
        XCTAssertEqual(requestable.commentCounts[5], 93, "Wrong number of comments")
    }

    func testCallAtIndex() {
        let requestable = MockCommentsController()
        let api = FirebaseAPI(requestable, TestFirebaseQuery(async: false))

        api.call(3)
        XCTAssertEqual(requestable.authors.count, 4, "Wrong number of usernames")
        XCTAssertEqual(requestable.authors[0], "sandworm101", "Wrong username")
        XCTAssertEqual(requestable.authors[1], "bifel", "Wrong username")
        XCTAssertEqual(requestable.authors[2], "simonh", "Wrong username")
        XCTAssertEqual(requestable.authors[3], "terryB", "Wrong username")
    }
}
