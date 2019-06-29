//
//  ViewController.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 27/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class NewsItemsViewController: UIViewController {
    var newsItemsTableView: NewsItemsView { return self.view as! NewsItemsView }

    private let reuseIdentifier = "cell"

    private func setupViews() {
        self.view = NewsItemsView(reuseIdentifier: reuseIdentifier)

        newsItemsTableView.dataSource = self
        newsItemsTableView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
}

extension NewsItemsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
}

extension NewsItemsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NewsItemViewCell
        cell.titleText = "How AMD Gave China the 'Keys to the Kingdom'"
        cell.commentText = "108 Comments"

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
