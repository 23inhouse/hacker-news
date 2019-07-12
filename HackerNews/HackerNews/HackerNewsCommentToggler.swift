//
//  HackerNewsCommentToggler.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 1/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

struct HackerNewsCommentToggler {
    let togglable: Togglable

    func toggleComments(at index: Int) -> [HackerNewsComment] {
        var flattenedComments = togglable.flattenedComments

        var flattenedParentComment = flattenedComments[index]
        flattenedParentComment.isFolded.toggle()
        flattenedComments[index] = flattenedParentComment

        var parentIdentifiers = [Int]()
        parentIdentifiers.append(flattenedParentComment.identifier)

        for (index, comment) in flattenedComments.enumerated() {
            guard let parentIdentifier = comment.parentIdentifier else { continue }

            var toggledComment = comment

            if parentIdentifiers.contains(parentIdentifier) {
                parentIdentifiers.append(comment.identifier)

                toggledComment.isHidden = flattenedParentComment.isFolded
                if flattenedParentComment.isFolded == false {
                    toggledComment.isFolded = false
                }
                flattenedComments[index] = toggledComment
            }
        }

        return flattenedComments
    }

    func toggledComments() -> [HackerNewsComment] {
        return togglable.flattenedComments.filter { comment in !comment.isHidden }
    }

    init(_ togglable: Togglable) {
        self.togglable = togglable
    }
}
