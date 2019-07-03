//
//  HackerNewsCommentTogglerTests.swift
//  HackerNewsTests
//
//  Created by Benjamin Lewis on 1/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest
@testable import HackerNews

struct MockTogglable: Togglable {
    var flattenedComments: [HackerNewsComment]

    struct MockFlattenable: Flattenable {
        var comments: [HackerNewsComment]
    }
}

class HackerNewsCommentTogglerTests: XCTestCase {

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

    func testToggledComments() {
        let flattenable = MockTogglable.MockFlattenable(comments: comments)
        let flattenComments = HackerNewsCommentFlattener(flattenable).flattenedComments()
        let togglable = MockTogglable(flattenedComments: flattenComments)
        let toggler = HackerNewsCommentToggler(togglable)

        let toggledComments = toggler.toggledComments(at: Int.random(in: 0 ..< flattenComments.count))
        XCTAssertEqual(toggledComments.count, 8, "Wrong number of toggled comments")
    }

    func testToggledCommentsFolded() {
        let flattenable = MockTogglable.MockFlattenable(comments: comments)
        let flattenComments = HackerNewsCommentFlattener(flattenable).flattenedComments()
        let togglable = MockTogglable(flattenedComments: flattenComments)
        let toggler = HackerNewsCommentToggler(togglable)

        for index in Array(0 ..< flattenComments.count) {
            let toggledComments = toggler.toggledComments(at: index)

            for (i, comment) in toggledComments.enumerated() {
                XCTAssertEqual(comment.isFolded, i == index, "Wrong isFolded value for comment #\(index)")
            }
        }
    }

    func testToggledCommentsHiddenChildren() {
        let flattenable = MockTogglable.MockFlattenable(comments: comments)
        let flattenComments = HackerNewsCommentFlattener(flattenable).flattenedComments()
        let togglable = MockTogglable(flattenedComments: flattenComments)
        let toggler = HackerNewsCommentToggler(togglable)

        let expectationOfHiddenChildren: [[Int]] = [
            [1, 4, 2, 3, 5, 6],
            [2, 3],
            [],
            [],
            [5, 6],
            [],
            [],
            [],
        ]

        for (index, expectatedHidden) in expectationOfHiddenChildren.enumerated() {
            let toggledComments = toggler.toggledComments(at: index)

            for (i, comment) in toggledComments.enumerated() {
                XCTAssertEqual(comment.isHidden, expectatedHidden.contains(i), "Wrong isHidden value for comment #\(index)")
            }
        }
    }

    func testToggledCommentsUnfoldingNestedChildren() {
        let flattenable = MockTogglable.MockFlattenable(comments: comments)
        let flattenComments = HackerNewsCommentFlattener(flattenable).flattenedComments()
        var togglable = MockTogglable(flattenedComments: flattenComments)

        // fold childer befor parents
        togglable.flattenedComments = HackerNewsCommentToggler(togglable).toggledComments(at: 2) // fold child of 1
        togglable.flattenedComments = HackerNewsCommentToggler(togglable).toggledComments(at: 1) // fold child of 0
        togglable.flattenedComments = HackerNewsCommentToggler(togglable).toggledComments(at: 0) // fold 0

        for i in [0, 1, 2] {
            let comment = togglable.flattenedComments[i]
            XCTAssertTrue(comment.isFolded, "Wrong isFolded value for comment #\(i)")
        }

        for i in [3, 4, 5, 6, 7] {
            let comment = togglable.flattenedComments[i]
            XCTAssertFalse(comment.isFolded, "Wrong isFolded value for comment #\(i)")
        }

        // unfold top level parent
        togglable.flattenedComments = HackerNewsCommentToggler(togglable).toggledComments(at: 0) // unfold 0

        for (i, comment) in togglable.flattenedComments.enumerated() {
            XCTAssertFalse(comment.isFolded, "Wrong isFolded value for comment #\(i)")
        }
    }

    func testToggledCommentsCallClosureForAllNestedChildren() {
        let flattenable = MockTogglable.MockFlattenable(comments: comments)
        let flattenComments = HackerNewsCommentFlattener(flattenable).flattenedComments()
        let togglable = MockTogglable(flattenedComments: flattenComments)

        var indexes = [Int]()

        HackerNewsCommentToggler(togglable).toggledComments(at: 1) { index in indexes.append(index) }

        XCTAssertEqual(indexes, [1, 2, 3], "Wrong output from closure")
    }
}
