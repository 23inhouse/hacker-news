//
//  Queryable.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 5/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

protocol Queryable {
    typealias QueryClosure = (Snapshottable?) -> Void
    typealias FirebaseTopStoryQuery = (@escaping QueryClosure) -> Void
    typealias FirebaseItemQuery = (Int, @escaping QueryClosure) -> Void

    var topStoryQuery: FirebaseTopStoryQuery { get }
    var itemQuery: FirebaseItemQuery { get }
}
