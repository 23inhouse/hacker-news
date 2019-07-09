//
//  TestSnapshot.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 9/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

struct TestSnapshot: Snapshottable {
    var value: Any!

    init(_ value: Any) {
        self.value = value
    }
}
