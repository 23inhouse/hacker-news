//
//  CommentsView.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 30/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class CommentsView: UITableView {
    init(reuseIdentifier: String, reuseHeaderIdentifier: String) {
        super.init(frame: .zero, style: .grouped)

        register(CommentViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        register(NewsItemViewHeaderCell.self, forHeaderFooterViewReuseIdentifier: reuseHeaderIdentifier)

        backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
