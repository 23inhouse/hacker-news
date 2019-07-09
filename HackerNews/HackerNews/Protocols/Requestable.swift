//
//  Requestable.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 3/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

protocol Requestable {
    func setData(_ data: [Datable])
    func setData(at index: Int, with data: Datable)
}
