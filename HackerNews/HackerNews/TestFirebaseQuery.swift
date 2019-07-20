//
//  TestFirebaseQuery.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 20/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

class TestFirebaseQuery: Queryable {
    var async: Bool = true
    let simutateNetworkLatency: () -> Void = { usleep(100000) }

    let stories: [Int: (title: String, commentCount: Int, kids: [Int])] = [
        1: ("Open Letter from the OpenID Foundation to Apple Regarding Sign in with Apple", 55, []),
        2: ("NASA plans to launch a spacecraft to Titan", 171, []),
        3: ("How AMD Gave China the 'Keys to the Kingdom'", 108, [11, 14]),
        4: ("The International Space Station is growing mold, inside and outside", 66, []),
        5: ("The Evolution of Lisp (1993) [pdf]", 0, []),
        6: ("Most Unit Testing Is Waste (2014) [pdf]", 93, []),
    ]

    typealias CommentData = [Int: (author: String, parent: Int, kids: [Int], time: Double, text: String)]
    let comments: [CommentData] = [
        [
            11: ("simonh", 3, [12], Date(timeIntervalSinceNow: -39600).timeIntervalSince1970, """
            Put everyone in a numbered sequence unknown to them. Add their chosen number to their sequence number, mod 10.
            This re-maps everyone’s choices so they actually have no idea what number they are actually choosing and efficiently redistributes the bias in their choices without massively complicated functions.
            It is also robust to changes in the distribution pattern. However it would only work well if you had at least 10 people and the number of people is divisible by 10.
            """),
            14: ("terryB", 3, [], Date(timeIntervalSinceNow: -139600).timeIntervalSince1970, "Lol not"),
        ],
        [
            12: ("bifel", 11, [13], Date(timeIntervalSinceNow: -1800).timeIntervalSince1970, """
            Wouldn't putting "everyone in a numbered sequence unknown to them" require a random number, which we don't have?
            """),
        ],
        [
            13: ("sandworm101", 12, [], Date(timeIntervalSinceNow: -60).timeIntervalSince1970, """
            Modern farming practices really help. The cows/pigs are kept far away, and downhill, of the fields growing vegetables.
            Irrigation water isn't contaminated. Humans are in minimal contact with the crop.
            Like it or not, epic agribusiness dramatically reduces the risk of cross-contamination between crops/livestocks/peoples.
            """),
        ]
    ]

    lazy var topStoryQuery: FirebaseTopStoryQuery = { closure in
        let value = [1, 2, 3, 4, 5, 6]
        let snap = TestSnapshot(value)
        self.simutateNetworkLatency()
        self.observeSingleEvent(snap, closure)
    }

    lazy var itemQuery: FirebaseItemQuery = { (id, closure) in
        let snap = id < 10 ? self.makeNewsSnapshot(for: id) : self.makeCommentSnapshot(for: id)
        self.simutateNetworkLatency()
        self.observeSingleEvent(snap, closure)
    }

    private func observeSingleEvent(_ snap: Snapshottable?, _ closure: @escaping QueryClosure) {
        async ? DispatchQueue.main.async { closure(snap) } : closure(snap)
    }

    private func makeNewsSnapshot(for id: Int) -> Snapshottable? {
        guard let story = stories[id] else { return nil }
        var value: [String: Any]
        value = [
            FirebaseConfig.Key.Id: id,
            FirebaseConfig.Key.Url: "https://127.0.0.1",
            FirebaseConfig.Key.Title: story.title,
            FirebaseConfig.Key.Author: "Mac",
            FirebaseConfig.Key.Score: 0,
            FirebaseConfig.Key.Kids: story.kids,
            FirebaseConfig.Key.CommentCount: story.commentCount,
        ]
        return TestSnapshot(value)
    }

    private func makeCommentSnapshot(for id: Int) -> Snapshottable? {
        var value: [String: Any]

        guard let nestedComments = comments[0][id] ?? comments[1][id] ?? comments[2][id] else { return nil }
        value = [
            FirebaseConfig.Key.Id: id,
            FirebaseConfig.Key.Author: nestedComments.author,
            FirebaseConfig.Key.Text: nestedComments.text,
            FirebaseConfig.Key.Parent: nestedComments.parent,
            FirebaseConfig.Key.Kids: nestedComments.kids,
            FirebaseConfig.Key.Time: nestedComments.time,
        ]
        return TestSnapshot(value)
    }

    init(async: Bool = true) {
        self.async = async
    }
}
