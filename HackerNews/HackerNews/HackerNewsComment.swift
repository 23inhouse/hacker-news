//
//  HackerNewsComment.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 30/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

struct HackerNewsComment {
    static var identiferFactory = 0

    let identifier: Int
    let body: NSAttributedString
    let username: String
    let timestamp: Date
    let comments: [HackerNewsComment]?
    let parentIdentifier: Int?
    let nestedLevel: Int
    var isFolded: Bool = false
    var isHidden: Bool = false

    static func getUniqueIdentifier() -> Int {
        identiferFactory += 1
        return identiferFactory
    }

    init(body: String, username: String, timestamp: Date, parentIdentifier: Int? = nil, nestedLevel: Int = 0, comments: (Int, Int) -> [HackerNewsComment]) {
        self.identifier = HackerNewsComment.getUniqueIdentifier()
        self.body = NSAttributedString(string: body)
        self.username = username
        self.timestamp = timestamp
        self.parentIdentifier = parentIdentifier
        self.nestedLevel = nestedLevel
        self.comments = comments(identifier, nestedLevel + 1)
    }

    init(body: String, username: String, timestamp: Date, parentIdentifier: Int? = nil, nestedLevel: Int = 0) {
        self.identifier = HackerNewsComment.getUniqueIdentifier()
        self.body = body
        self.username = username
        self.timestamp = timestamp
        self.comments = nil
        self.parentIdentifier = parentIdentifier
        self.nestedLevel = nestedLevel
    }
}

class HackerNewsFirebaseComment {
    let id: Int
    let author: String
    let text: String
    let parent: Int
    let kids: [Int]?
    let timestamp: Date?
    var data: [String: Any]?

    init?(data: Snapshottable?) {
        guard
            let data = data?.value as? [String: Any],
            let id = data[FirebaseConfig.Key.Id] as? Int,
            let author = data[FirebaseConfig.Key.Author] as? String?,
            let text = data[FirebaseConfig.Key.Text] as? String?,
            let parent = data[FirebaseConfig.Key.Parent] as? Int,
            let kids = data[FirebaseConfig.Key.Kids] as? [Int]?,
            let time = data[FirebaseConfig.Key.Time] as? Double
            else { return nil }
        self.data = data
        self.id = id
        self.author = author ?? "[deleted]"
        self.text = text ?? ""
        self.parent = parent
        self.kids = kids
        self.timestamp = Date(timeIntervalSince1970: time)
    }
}
