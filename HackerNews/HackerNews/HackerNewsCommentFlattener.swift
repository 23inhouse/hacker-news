//
//  HackerNewsCommentFlattener.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 30/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

protocol Flattenable {
    var comments: [HackerNewsComment] { get }
}

struct HackerNewsCommentFlattener {
    let flattenable: Flattenable

    func flattenedComments() -> [HackerNewsComment] {
        return recurseComments(comments: flattenable.comments)
    }

    private func recurseComments(comments: [HackerNewsComment]) -> [HackerNewsComment] {
        var flattenedComments = [HackerNewsComment]()

        for comment in comments {
            flattenedComments.append(comment)
            if let comments = comment.comments {
                for comment in recurseComments(comments: comments) {
                    flattenedComments.append(comment)
                }
            }
        }
        return flattenedComments
    }

    init(_ flattenable: Flattenable) {
        self.flattenable = flattenable
    }
}
