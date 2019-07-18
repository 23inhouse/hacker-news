//
//  CommentsViewController.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 30/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController, Flattenable, Togglable {
    lazy var commentsTableView: CommentsView = CommentsView(reuseIdentifier: reuseIdentifier, reuseHeaderIdentifier: reuseHeaderIdentifier)
    let refreshControl = UIRefreshControl()

    private let reuseIdentifier = "commentCell"
    private let reuseHeaderIdentifier = "newsItemCell"

    var cellHeights = [IndexPath: CGFloat]()

    private lazy var navigationBar: UIView? = {
        guard let navigationController = navigationController as? MainViewController else { return nil }
        return navigationController.navigationBar
    }()

    private lazy var searchBar: UIView? = {
        guard let navigationController = navigationController as? MainViewController else { return nil }
        return navigationController.searchBar
    }()

    private lazy var firebaseRequest = FirebaseAPI(self)

    private var newsItem: HackerNewsItem!

    var comments = [HackerNewsComment]() {
        didSet {
            flattenedComments = HackerNewsCommentFlattener(self).flattenedComments()
            toggledComments = flattenedComments
        }
    }
    var flattenedComments = [HackerNewsComment]()
    var toggledComments = [HackerNewsComment]()

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(commentsTableView)
        commentsTableView.constrain(to: view.safeAreaLayoutGuide)

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
        navigationBar?.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationBar?.isHidden = false
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
        let newsItem = data as! HackerNewsItem
        self.newsItem = newsItem
    }
}

extension CommentsViewController: UIGestureRecognizerDelegate {
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        guard let url = URL(string: newsItem.url) else { return }

        let articleVC = NewsArticleViewController(url)
        navigationController?.present(articleVC, animated: false, completion: nil)
    }
}

extension CommentsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toggledComments.count
    }
}

// MARK: Table Cells
extension CommentsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CommentViewCell

        let comment = toggledComments[indexPath.row]
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
        guard !toggledComments[indexPath.row].isFolded else { return 40 }

        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let frame = tableView.rectForRow(at: indexPath)

        self.cellHeights[indexPath] = frame.size.height
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeights[indexPath] ?? 300
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let index = HackerNewsCommentIndexConverter(self).convert(from: indexPath.row) else { return }

        flattenedComments = HackerNewsCommentToggler(self).toggleComments(at: index)
        toggledComments = HackerNewsCommentToggler(self).toggledComments()

        var cellRect = tableView.rectForRow(at: indexPath)
        cellRect = cellRect.offsetBy(dx: -tableView.contentOffset.x, dy: -tableView.contentOffset.y)
        tableView.reloadData()
        if cellRect.minY < 5 {
            tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: false)
        }
    }
}

// MARK: Table Header
extension CommentsViewController {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = commentsTableView.dequeueReusableHeaderFooterView(withIdentifier: "newsItemCell") as! NewsItemViewHeaderCell

        cell.titleText = newsItem.title
        cell.commentText = "\(newsItem.commentCount) Comments"
        cell.urlText = newsItem.host()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapRecognizer.delegate = self
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        cell.addGestureRecognizer(tapRecognizer)

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
