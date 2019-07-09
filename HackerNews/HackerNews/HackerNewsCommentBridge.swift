//
//  HackerNewsCommentBridge.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 4/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

struct HackerNewsCommentBridge {
    static func call(from other: HackerNewsFirebaseComment, parentIdentifier: Int? = nil, nestedLevel: Int? = nil) -> HackerNewsComment {
        return HackerNewsComment(
            body: HackerNewsCommentFormatter.call(other.text),
            username: other.author,
            timestamp: other.timestamp,
            identifier: other.id,
            parentIdentifier: parentIdentifier ?? other.parent,
            nestedLevel: nestedLevel ?? 0
        )
    }

    static func call(from others: [HackerNewsFirebaseComment]) -> [HackerNewsComment] {
        return others.map { other in HackerNewsCommentBridge.call(from: other) }
    }
}
