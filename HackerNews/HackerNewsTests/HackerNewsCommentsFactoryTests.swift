//
//  HackerNewsCommentsFactoryTests.swift
//  HackerNewsTests
//
//  Created by Benjamin Lewis on 6/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest
@testable import HackerNews

class HackerNewsCommentsFactoryTests: XCTestCase {
    func testMakeComments() {
        let id1 = 1
        let id2 = 2
        let parentComments = [
            HackerNewsComment(body: "body", username: "name", timestamp: Date(timeIntervalSinceNow: -39600), identifier: id1),
            HackerNewsComment(body: "body", username: "name", timestamp: Date(timeIntervalSinceNow: -139600), identifier: id2),
        ]

        let childComments = [
            makeFirebaseComment(id: 3, parent: 1),
            makeFirebaseComment(id: 4, parent: 1),
            makeFirebaseComment(id: 5, parent: 1),
        ]

        let grandchildComments = [
            makeFirebaseComment(id: 6, parent: 4),
            makeFirebaseComment(id: 7, parent: 4),
            makeFirebaseComment(id: 8, parent: 4),
            makeFirebaseComment(id: 9, parent: 4),
        ]

        var factory: HackerNewsCommentsFactory
        var comments: [HackerNewsComment]

        factory = HackerNewsCommentsFactory(comments: parentComments)
        comments = factory.makeComments(childComments)!
        factory = HackerNewsCommentsFactory(comments: comments)

        comments = factory.makeComments(grandchildComments)!
        XCTAssertEqual(comments.count, 2, "Wrong number of parent comments")

        let comment = comments[0]
        XCTAssertEqual(comment.comments!.count, 3, "Wrong number of child comments")

        let childComment = comment.comments![1]
        XCTAssertEqual(childComment.comments!.count, 4, "Wrong number of grand child comments")
    }

    private func makeFirebaseComment(id: Int, parent: Int) -> HackerNewsFirebaseComment {
        let snapshotValue: [String: Any] = [
            FirebaseConfig.Key.Id: id,
            FirebaseConfig.Key.Author: "author",
            FirebaseConfig.Key.Text: "<p>text</p>",
            FirebaseConfig.Key.Parent: parent,
            FirebaseConfig.Key.Kids: [],
            FirebaseConfig.Key.Time: Date().timeIntervalSince1970,
        ]
        let snapshot = TestSnapshot(snapshotValue)
        return HackerNewsFirebaseComment(data: snapshot)!
    }
}
