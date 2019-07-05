//
//  CommentsViewController.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 30/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController, Flattenable, Togglable {
    var commentsTableView: CommentsView { return self.view as! CommentsView }
    let refreshControl = UIRefreshControl()

    private let reuseIdentifier = "commentCell"
    private let reuseHeaderIdentifier = "newsItemCell"

    private lazy var searchBar: UIView? = {
        guard let navigationController = navigationController as? MainViewController else { return nil }
        return navigationController.searchBar
    }()

    private lazy var firebaseRequest = FirebaseAPI(self)

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

        let commentCount = newsItem.commentCount
        self.comments = [HackerNewsComment](repeating: HackerNewsComment.Empty, count: commentCount)

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        commentsTableView.addSubview(refreshControl)

        firebaseRequest.call(newsItem.id)
    }

    @objc private func refresh(sender: AnyObject) {
        firebaseRequest.call(newsItem.id)
        refreshControl.endRefreshing()
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

extension CommentsViewController: Requestable {

    func setData(_ data: [Datable]) {
        let data = data as! [HackerNewsFirebaseComment]
        guard !data.isEmpty else { return }
        guard data[0].parent != newsItem.id else {
            comments = HackerNewsCommentBridge.call(from: data)
            commentsTableView.reloadData()
            return
        }

        if let updatedComments = HackerNewsCommentsFactory(comments: comments).makeComments(data) {
            comments = updatedComments
            commentsTableView.reloadData()
        }
    }

    func setData(at index: Int, with data: Datable) {
        comments[index] = data as! HackerNewsComment
    }

    func reloadRow(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        commentsTableView.reloadRows(at: [indexPath], with: .fade)
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

        if comment.timestamp != nil {
            cell.setIndentConstant(comment.nestedLevel)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard !flattenedComments[indexPath.row].isHidden else { return 0 }
        guard !flattenedComments[indexPath.row].isFolded else { return 40 }

        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
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
