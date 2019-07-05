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

    private lazy var firebaseRequest = FirebaseAPI(self)

    internal var newsItems = [HackerNewsItem](repeating: HackerNewsItem.Empty, count: 6) {
        didSet {
            newsItemsTableView.reloadData()
        }
    }

    var newsItemFilter: String = "" {
        didSet {
            newsItemsTableView.reloadData()
            guard filteredNewsItems().count > 0 else { return }
            newsItemsTableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
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

        firebaseRequest.call()
    }
}

extension NewsItemsViewController: Requestable {

    func setData(_ data: [Datable]) {
        newsItems = data as! [HackerNewsItem]
    }

    func setData(at index: Int, with data: Datable) {
        newsItems[index] = data as! HackerNewsItem
    }

    func reloadRow(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        newsItemsTableView.reloadRows(at: [indexPath], with: .fade)
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
        if !newsItem.title.isEmpty {
            cell.titleText = newsItem.title
            cell.commentText = "\(newsItem.commentCount) Comments"
        }

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
