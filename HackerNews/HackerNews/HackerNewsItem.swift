//
//  HackerNewsItem.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 29/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

class HackerNewsItem {
    let id: Int
    let url: String?
    let title: String
    let author: String
    let score: Int
    let kids: [Int]?
    let commentCount: Int
    init?(data: Snapshottable?) {
        guard
            let data = data?.value as? [String: Any],
            let id = data[FirebaseConfig.Key.Id] as? Int,
            let url = data[FirebaseConfig.Key.Url] as? String?,
            let title = data[FirebaseConfig.Key.Title] as? String,
            let author = data[FirebaseConfig.Key.Author] as? String,
            let score = data[FirebaseConfig.Key.Score] as? Int,
            let kids = data[FirebaseConfig.Key.Kids] as? [Int]?,
            let commentCount = data[FirebaseConfig.Key.CommentCount] as? Int
        else { return nil }
        self.id = id
        self.url = url
        self.title = title
        self.author = author
        self.score = score
        self.kids = kids
        self.commentCount = commentCount
    }

    init(title: String, commentCount: Int) {
        self.id = 0
        self.url = "url"
        self.title = title
        self.author = "author"
        self.score = 0
        self.kids = [Int]()
        self.commentCount = commentCount
    }
}
