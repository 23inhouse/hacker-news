//
//  HackerNewsCommentBridgeTests.swift
//  HackerNewsTests
//
//  Created by Benjamin Lewis on 6/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest
@testable import HackerNews

class HackerNewsCommentBridgeTests: XCTestCase {
    func testCallFromOne() {
        let snapshotValue: [String: Any] = [
            FirebaseConfig.Key.Id: 2,
            FirebaseConfig.Key.Author: "author",
            FirebaseConfig.Key.Text: "<p>text</p>",
            FirebaseConfig.Key.Parent: 1,
            FirebaseConfig.Key.Kids: [3, 4],
            FirebaseConfig.Key.Time: Date().timeIntervalSince1970,
        ]
        let snapshot = TestSnapshot(snapshotValue)
        let hackerNewsFirebaseComment = HackerNewsFirebaseComment(data: snapshot)!

        let expectations: [(Int?, Int?, Int, Int)] = [
            (nil, nil, 1, 0),
            (2, 3, 2, 3),
        ]

        for expectation in expectations {
            let (parentIdentifier, nestedLevel, expectedParentIdentifier, expectedNestedLevel) = expectation
            let hackerNewsComment = HackerNewsCommentBridge.call(from: hackerNewsFirebaseComment, parentIdentifier: parentIdentifier, nestedLevel: nestedLevel)
            XCTAssertEqual(hackerNewsComment.identifier, 2, "Wrong identifier")
            XCTAssertEqual(hackerNewsComment.username, "author", "Wrong username")
            XCTAssertEqual(hackerNewsComment.body.string, "text", "Wrong body")
            XCTAssertNil(hackerNewsComment.comments, "Wrong comments")
            XCTAssertEqual(hackerNewsComment.parentIdentifier, expectedParentIdentifier, "Wrong parent Identifier")
            XCTAssertEqual(hackerNewsComment.nestedLevel, expectedNestedLevel, "Wrong nested level")
        }
    }

    func testCallFromMultiple() {
        let snapshotValue: [String: Any] = [
            FirebaseConfig.Key.Id: 2,
            FirebaseConfig.Key.Author: "author",
            FirebaseConfig.Key.Text: "<p>text</p>",
            FirebaseConfig.Key.Parent: 1,
            FirebaseConfig.Key.Kids: [3, 4],
            FirebaseConfig.Key.Time: Date().timeIntervalSince1970,
        ]
        let snapshot = TestSnapshot(snapshotValue)
        let hackerNewsFirebaseComment = HackerNewsFirebaseComment(data: snapshot)!

        let hackerNewsComments = HackerNewsCommentBridge.call(from: [hackerNewsFirebaseComment, hackerNewsFirebaseComment])
        XCTAssertEqual(hackerNewsComments.count, 2, "Wrong number")
        XCTAssertEqual(hackerNewsComments[0].username, "author", "Wrong author")
        XCTAssertEqual(hackerNewsComments[1].username, "author", "Wrong author")
    }
}
