//
//  FirebaseRequest.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 3/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation
import Firebase

class FirebaseQuery: Queryable {
    private var firebase = Firebase(url: FirebaseConfig.Url)

    lazy var topStoryQuery: FirebaseTopStoryQuery = { closure in
        let query = self.firebase?
            .child(byAppendingPath: FirebaseConfig.TypeChildRef)
            .queryLimited(toFirst: FirebaseConfig.ItemLimit)
        query?.observeSingleEvent(of: .value, with: closure)
    }

    lazy var itemQuery: FirebaseItemQuery = { (id, closure) in
        let query = self.firebase?
            .child(byAppendingPath: FirebaseConfig.ItemChildRef)
            .child(byAppendingPath: String(id))
        query?.observeSingleEvent(of: .value, with: closure)
    }
}
extension FDataSnapshot: Snapshottable {}
