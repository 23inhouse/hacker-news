//
//  Firebasable.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 3/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

protocol Firebasable {
    var requestable: Requestable { get }
    func call()
    func call(_ id: Int)
}
