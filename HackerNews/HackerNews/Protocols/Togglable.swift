//
//  Togglable.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 13/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

protocol Togglable {
    var flattenedComments: [HackerNewsComment] { get }
    var toggledComments: [HackerNewsComment] { get }
}
