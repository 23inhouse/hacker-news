//
//  HackerNewsCommentFlattenerTests.swift
//  HackerNewsTests
//
//  Created by Benjamin Lewis on 30/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest
@testable import HackerNews

struct MockFlattenable: Flattenable {
    var comments: [HackerNewsComment]
}

class HackerNewsCommentFlattenerTests: XCTestCase {
    let comments: [HackerNewsComment] = [
        HackerNewsComment(body: "body 1", username: "username", timestamp: Date()) { parentIdentifier, nestedLevel in
            [
                HackerNewsComment(body: "body 2", username: "username", timestamp: Date(), parentIdentifier: parentIdentifier, nestedLevel: nestedLevel) { parentIdentifier, nestedLevel in
                    [
                        HackerNewsComment(body: "body 3", username: "username", timestamp: Date(), parentIdentifier: parentIdentifier, nestedLevel: nestedLevel),
                        HackerNewsComment(body: "body 4", username: "username", timestamp: Date(), parentIdentifier: parentIdentifier, nestedLevel: nestedLevel),
                    ]
                },
                HackerNewsComment(body: "body 5", username: "username", timestamp: Date(), parentIdentifier: parentIdentifier, nestedLevel: nestedLevel) { parentIdentifier, nestedLevel in
                    [
                        HackerNewsComment(body: "body 6", username: "username", timestamp: Date(), parentIdentifier: parentIdentifier, nestedLevel: nestedLevel),
                        HackerNewsComment(body: "body 7", username: "username", timestamp: Date(), parentIdentifier: parentIdentifier, nestedLevel: nestedLevel),
                    ]
                },
            ]
        },
        HackerNewsComment(body: "body 8", username: "username", timestamp: Date()),
    ]

    func testFlattenedCommentsCount() {
        let flattenable = MockFlattenable(comments: comments)
        let flattener = HackerNewsCommentFlattener(flattenable)
        XCTAssertEqual(flattener.flattenedComments().count, 8, "Wrong number of flattened comments")
    }

    func testFlattenedCommentsAssociations() {
        let expectations: [(String, Int?, Int)] = [
            ("body 1", nil, 0),
            ("body 2", 1, 1),
            ("body 3", 2, 2),
            ("body 4", 2, 2),
            ("body 5", 1, 1),
            ("body 6", 5, 2),
            ("body 7", 5, 2),
            ("body 8", nil, 0),
        ]

        let flattenable = MockFlattenable(comments: comments)

        for (i, expectation) in expectations.enumerated() {
            let (body, parentIdentifier, nestedLevel) = expectation
            let flattener = HackerNewsCommentFlattener(flattenable)
            let comment = flattener.flattenedComments()[i]
            XCTAssertEqual(comment.body, body, "Wrong body value")
            XCTAssertEqual(comment.parentIdentifier, parentIdentifier, "Wrong parentIdentifer for \(comment.body)")
            XCTAssertEqual(comment.nestedLevel, nestedLevel, "Wrong nestedLevel for \(comment.body)")
        }
    }
}
