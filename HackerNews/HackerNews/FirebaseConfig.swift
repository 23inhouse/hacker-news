//
//  FirebaseConfig.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 3/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

struct FirebaseConfig {
    static let Url = "https://hacker-news.firebaseio.com/v0/"
    static let ItemChildRef = "item"
    static let TypeChildRef = "topstories"
    static let ItemLimit: UInt = 500

    struct Key {
        static let Id = "id"
        static let Url = "url"
        static let Title = "title"
        static let Author = "by"
        static let Text = "text"
        static let Score = "score"
        static let Parent = "parent"
        static let Kids = "kids"
        static let CommentCount = "descendants"
        static let Time = "time"
    }
}
