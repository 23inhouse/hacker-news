//
//  HackerNewsCommentsFactory.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 4/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

class HackerNewsCommentsFactory {
    var comments: [HackerNewsComment]

    func makeComments(_ data: [HackerNewsFirebaseComment]) -> [HackerNewsComment]? {
        guard !data.isEmpty else { return comments }

        let parentIdentifier = data[0].parent

        guard let index = comments.firstIndex(where: { $0.identifier == parentIdentifier }) else {
            for (index, comment) in comments.enumerated() {
                guard let childComments = comment.comments else { continue }
                let updatedComments = HackerNewsCommentsFactory(comments: childComments).makeComments(data)
                comments[index] = HackerNewsComment(from: comment, comments: updatedComments!)
            }
            return comments
        }

        comments[index] = HackerNewsComment(from: comments[index]) { parentIdentifer, nestedLevel in
            data.map { comment in HackerNewsCommentBridge.call(from: comment, parentIdentifier: parentIdentifer, nestedLevel: nestedLevel) }
        }
        return comments

    }

    init(comments: [HackerNewsComment]) {
        self.comments = comments
    }
}
