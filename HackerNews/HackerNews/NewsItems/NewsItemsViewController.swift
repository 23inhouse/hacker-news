//
//  ViewController.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 27/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class NewsItemsViewController: UIViewController, Filterable {
    var newsItemsTableView: NewsItemsView { return self.view as! NewsItemsView }

    private let reuseIdentifier = "newsItemCell"

    internal var newsItems: [HackerNewsItem] = [
        HackerNewsItem(title: "Open Letter from the OpenID Foundation to Apple Regarding Sign in with Apple", commentCount: 55),
        HackerNewsItem(title: "NASA plans to launch a spacecraft to Titan", commentCount: 171),
        HackerNewsItem(title: "How AMD Gave China the 'Keys to the Kingdom'", commentCount: 108),
        HackerNewsItem(title: "The International Space Station is growing mold, inside and outside", commentCount: 66),
        HackerNewsItem(title: "The Evolution of Lisp (1993) [pdf]", commentCount: 0),
        HackerNewsItem(title: "Most Unit Testing Is Waste (2014) [pdf]", commentCount: 93),
    ]

    var newsItemFilter: String = "" {
        didSet {
            newsItemsTableView.reloadData()
        }
    }

    private func filteredNewsItems() -> [HackerNewsItem] {
        return HackerNewsFilter(self).filteredItems()
    }

    private func setupViews() {
        self.view = NewsItemsView(reuseIdentifier: reuseIdentifier)

        newsItemsTableView.dataSource = self
        newsItemsTableView.delegate = self
        newsItemsTableView.keyboardDismissMode = .onDrag
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
}

extension NewsItemsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNewsItems().count
    }
}

extension NewsItemsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NewsItemViewCell

        let newsItem = filteredNewsItems()[indexPath.row]
        cell.titleText = newsItem.title
        cell.commentText = "\(newsItem.commentCount) Comments"

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsItem = filteredNewsItems()[indexPath.row]
        let commentsVC = CommentsViewController(newsItem)
        navigationController?.pushViewController(commentsVC, animated: true)
    }
}
