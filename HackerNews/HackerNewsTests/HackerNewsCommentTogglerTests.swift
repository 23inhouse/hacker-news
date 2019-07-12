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
    var toggledComments: [HackerNewsComment]

    struct MockFlattenable: Flattenable {
        var comments: [HackerNewsComment]
    }

    init(flattenedComments: [HackerNewsComment]) {
        self.flattenedComments = flattenedComments
        self.toggledComments = flattenedComments
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
        let flattenedComments = HackerNewsCommentFlattener(flattenable).flattenedComments()
        var togglable = MockTogglable(flattenedComments: flattenedComments)
        let toggler = HackerNewsCommentToggler(togglable)

        togglable.flattenedComments = toggler.toggleComments(at: Int.random(in: 0 ..< flattenedComments.count))
        XCTAssertEqual(togglable.flattenedComments.count, 8, "Wrong number of toggled comments")
    }

    func testToggleComments() {
        let flattenable = MockTogglable.MockFlattenable(comments: comments)
        let flattenedComments = HackerNewsCommentFlattener(flattenable).flattenedComments()
        var togglable = MockTogglable(flattenedComments: flattenedComments)
        let toggler = HackerNewsCommentToggler(togglable)

        togglable.flattenedComments = toggler.toggleComments(at: 0)
        let toggledComments = HackerNewsCommentToggler(togglable).toggledComments()
        XCTAssertEqual(toggledComments.count, 2, "Wrong number of toggled comments")
    }

    func testToggledCommentsFolded() {
        let flattenable = MockTogglable.MockFlattenable(comments: comments)
        var flattenedComments = HackerNewsCommentFlattener(flattenable).flattenedComments()
        let togglable = MockTogglable(flattenedComments: flattenedComments)
        let toggler = HackerNewsCommentToggler(togglable)

        for index in Array(0 ..< flattenedComments.count) {
            flattenedComments = toggler.toggleComments(at: index)

            for (i, comment) in flattenedComments.enumerated() {
                XCTAssertEqual(comment.isFolded, i == index, "Wrong isFolded value for comment #\(index)")
            }
        }
    }

    func testToggledCommentsHiddenChildren() {
        let flattenable = MockTogglable.MockFlattenable(comments: comments)
        var flattenedComments = HackerNewsCommentFlattener(flattenable).flattenedComments()
        let togglable = MockTogglable(flattenedComments: flattenedComments)
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
            flattenedComments = toggler.toggleComments(at: index)

            for (i, comment) in flattenedComments.enumerated() {
                XCTAssertEqual(comment.isHidden, expectatedHidden.contains(i), "Wrong isHidden value for comment #\(index)")
            }
        }
    }

    func testToggledCommentsUnfoldingNestedChildren() {
        let flattenable = MockTogglable.MockFlattenable(comments: comments)
        let flattenedComments = HackerNewsCommentFlattener(flattenable).flattenedComments()
        var togglable = MockTogglable(flattenedComments: flattenedComments)

        // fold childer befor parents
        togglable.flattenedComments = HackerNewsCommentToggler(togglable).toggleComments(at: 2) // fold child of 1
        togglable.flattenedComments = HackerNewsCommentToggler(togglable).toggleComments(at: 1) // fold child of 0
        togglable.flattenedComments = HackerNewsCommentToggler(togglable).toggleComments(at: 0) // fold 0

        for i in [0, 1, 2] {
            let comment = togglable.flattenedComments[i]
            XCTAssertTrue(comment.isFolded, "Wrong isFolded value for comment #\(i)")
        }

        for i in [3, 4, 5, 6, 7] {
            let comment = togglable.flattenedComments[i]
            XCTAssertFalse(comment.isFolded, "Wrong isFolded value for comment #\(i)")
        }

        // unfold top level parent
        togglable.flattenedComments = HackerNewsCommentToggler(togglable).toggleComments(at: 0) // unfold 0

        for (i, comment) in togglable.flattenedComments.enumerated() {
            XCTAssertFalse(comment.isFolded, "Wrong isFolded value for comment #\(i)")
        }
    }
}
