//
//  Int+of.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 30/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

extension Int {
    func of(_ name: String) -> String {
        guard self != 1 else { return "\(self) \(name)" }
        return "\(self) \(name)s"
    }
}
