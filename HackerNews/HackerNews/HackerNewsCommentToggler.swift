//
//  HackerNewsCommentToggler.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 1/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

protocol Togglable {
    var flattenedComments: [HackerNewsComment] { get }
}

struct HackerNewsCommentToggler {
    let togglable: Togglable

    @discardableResult
    func toggledComments(at index: Int, closure: ((Int) -> Void)? = nil) -> [HackerNewsComment] {
        var toggledComments = togglable.flattenedComments

        var toggledParentComment = toggledComments[index]
        toggledParentComment.isFolded.toggle()
        toggledComments[index] = toggledParentComment

        if let closure = closure {
            closure(index)
        }

        var parentIdentifiers = [Int]()
        parentIdentifiers.append(toggledParentComment.identifier)

        for (index, comment) in toggledComments.enumerated() {
            guard let parentIdentifier = comment.parentIdentifier else { continue }

            guard parentIdentifiers.contains(parentIdentifier) else { continue }
            parentIdentifiers.append(comment.identifier)

            var toggledComment = comment
            toggledComment.isHidden = toggledParentComment.isFolded
            if toggledParentComment.isFolded == false {
                toggledComment.isFolded = false
            }
            toggledComments[index] = toggledComment

            if let closure = closure {
                closure(index)
            }
        }

        return toggledComments
    }

    init(_ togglable: Togglable) {
        self.togglable = togglable
    }
}
