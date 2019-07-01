//
//  CommentsViewController.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 30/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

let comment1 = """
Put everyone in a numbered sequence unknown to them. Add their chosen number to their sequence number, mod 10.
This re-maps everyone’s choices so they actually have no idea what number they are actually choosing and efficiently redistributes the bias in their choices without massively complicated functions. It is also robust to changes in the distribution pattern. However it would only work well if you had at least 10 people and the number of people is divisible by 10.
"""
let comment2 = """
Wouldn't putting "everyone in a numbered sequence unknown to them" require a random number, which we don't have?
"""
let comment3 = """
Modern farming practices really help. The cows/pigs are kept far away, and downhill, of the fields growing vegetables. Irrigation water isn't contaminated. Humans are in minimal contact with the crop. Like it or not, epic agribusiness dramatically reduces the risk of cross-contamination between crops/livestocks/peoples.
"""
let tempComments: [HackerNewsComment] = [
    HackerNewsComment(body: comment1, username: "simonh", timestamp: Date(timeIntervalSinceNow: -39600)) { parentIdentifier, nestedLevel in
        [
            HackerNewsComment(body: comment2, username: "bifel", timestamp: Date(timeIntervalSinceNow: -1800), parentIdentifier: parentIdentifier, nestedLevel: nestedLevel) { parentIdentifier, nestedLevel in
                [
                    HackerNewsComment(body: comment3, username: "sandworm101", timestamp: Date(timeIntervalSinceNow: -60), parentIdentifier: parentIdentifier, nestedLevel: nestedLevel)
                ]
            }
        ]
    },
    HackerNewsComment(body: comment1, username: "terryB", timestamp: Date(timeIntervalSinceNow: -139600))
]

class CommentsViewController: UIViewController, Flattenable, Togglable {
    var commentsTableView: CommentsView { return self.view as! CommentsView }

    private let reuseIdentifier = "commentCell"
    private let reuseHeaderIdentifier = "newsItemCell"

    private lazy var searchBar: UIView? = {
        guard let navigationController = navigationController as? MainViewController else { return nil }
        return navigationController.searchBar
    }()

    private let newsItem: HackerNewsItem!

    var comments = [HackerNewsComment]() {
        didSet {
            flattenedComments = HackerNewsCommentFlattener(self).flattenedComments()
        }
    }
    var flattenedComments = [HackerNewsComment]()

    private func setupViews() {
        self.view = CommentsView(reuseIdentifier: reuseIdentifier, reuseHeaderIdentifier: reuseHeaderIdentifier)

        commentsTableView.dataSource = self
        commentsTableView.delegate = self

        self.comments = tempComments
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        searchBar?.endEditing(true)
        searchBar?.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        searchBar?.isHidden = false
    }

    init(_ newsItem: HackerNewsItem) {
        self.newsItem = newsItem
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CommentsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flattenedComments.count
    }
}

// MARK: Table Cells
extension CommentsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CommentViewCell

        let comment = flattenedComments[indexPath.row]
        cell.usernameText = comment.username
        cell.timestampDate = comment.timestamp
        cell.commentText = comment.body
        cell.isFolded = comment.isFolded
        cell.isHidden = comment.isHidden

        cell.setIndentConstant(comment.nestedLevel)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard !flattenedComments[indexPath.row].isHidden else { return 0 }

        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var indexPaths = [IndexPath]()

        flattenedComments = HackerNewsCommentToggler(self).toggledComments(at: indexPath.row) { index in
            let indexPath = IndexPath(row: index, section: 0)
            indexPaths.append(indexPath)
        }

        tableView.reloadRows(at: indexPaths, with: .fade)
    }
}

// MARK: Table Header
extension CommentsViewController {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = commentsTableView.dequeueReusableHeaderFooterView(withIdentifier: "newsItemCell") as! NewsItemViewHeaderCell

        cell.titleText = newsItem.title
        cell.commentText = "\(newsItem.commentCount) Comments"

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }

}

// MARK: Table Footer
extension CommentsViewController {

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = commentsTableView.dequeueReusableHeaderFooterView(withIdentifier: "newsItemCell") as! NewsItemViewHeaderCell

        cell.titleText = ""
        cell.commentText = ""

        return cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 500
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 500
    }
}
