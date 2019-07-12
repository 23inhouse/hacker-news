//
//  HackerNewsCommentIndexConverter.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 13/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

struct HackerNewsCommentIndexConverter {
    let togglable: Togglable

    func convert(from index: Int) -> Int? {
        let flattenedComments = togglable.flattenedComments
        let toggledComment = togglable.toggledComments[index]
        return flattenedComments.firstIndex(where: { comment in comment.identifier == toggledComment.identifier })
    }

    init(_ togglable: Togglable) {
        self.togglable = togglable
    }
}
