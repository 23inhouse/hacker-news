//
//  HackerNewsFilterTests.swift
//  HackerNewsTests
//
//  Created by Benjamin Lewis on 29/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest
@testable import HackerNews

struct MockFilterable: Filterable {
    var newsItems: [HackerNewsItem]
    var newsItemFilter: String
}

class HackerNewsFilterTests: XCTestCase {
    func testUnfiltered() {

        let newsItems = [
            HackerNewsItem(title: "First one with text", commentCount: 0),
            HackerNewsItem(title: "Second one with text", commentCount: 0),
            HackerNewsItem(title: "Third one with more text", commentCount: 0),
        ]
        let expectations: [(String, Int)] = [
            ("First", 1),
            ("with text", 3),
            ("more text", 1),
        ]

        var filterable = MockFilterable(newsItems: newsItems, newsItemFilter: "")

        for expectation in expectations {
            let (filterText, count) = expectation
            filterable.newsItemFilter = filterText
            let filter = HackerNewsFilter(filterable)
            XCTAssertEqual(filter.filteredItems().count, count, "Wrong number of filtered items")

        }
    }
}
