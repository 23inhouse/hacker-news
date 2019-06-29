//
//  NewsItemsView.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 28/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class NewsItemsView: UITableView {
    init(reuseIdentifier: String) {
        super.init(frame: .zero, style: .plain)

        register(NewsItemViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
