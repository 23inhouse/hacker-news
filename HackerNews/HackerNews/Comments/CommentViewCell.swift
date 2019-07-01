//
//  CommentViewCell.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 30/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class CommentViewCell: UITableViewCell {
    private let whitespaceSize: CGFloat = 10

    var usernameText: String = " " {
        didSet { username.textContent = usernameText }
    }
    var timestampDate: Date? = nil {
        didSet {
            timestamp.textContent = {
                guard let timestampDate = timestampDate else { return " " }
                return Date.time(since: timestampDate)
            }()
        }
    }
    var commentText: String = " " {
        didSet { comment.textContent = commentText }
    }

    var isFolded: Bool = false {
        didSet {
            comment.isHidden = isFolded
        }
    }

    lazy private var leadingAnchorConstraint: NSLayoutConstraint = {
        stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: whitespaceSize)
    }()

    lazy private var bottomAnchorConstraint: NSLayoutConstraint = {
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -whitespaceSize)
    }()

    lazy var stackConstraints: [NSLayoutConstraint] = [
        leadingAnchorConstraint,
        stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -whitespaceSize),
        stack.topAnchor.constraint(equalTo: topAnchor, constant: whitespaceSize),
        bottomAnchorConstraint,
    ]

    let wrapper = UIView ()

    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()

    private let metadataStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()

    lazy var username: StyledCellLabel = {
        let label = StyledCellLabel()
        label.textContent = usernameText
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        return label
    }()

    lazy var timestamp: StyledCellLabel = {
        let label = StyledCellLabel()
        label.textContent = {
            guard let timestampDate = timestampDate else { return " " }
            return Date.time(since: timestampDate)
        }()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .lightGray
        return label
    }()

    lazy var comment: StyledCellLabel = {
        let label = StyledCellLabel()
        label.textContent = commentText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .darkGray
        return label
    }()

    func setIndentConstant(_ nestedLevel: Int) {
        let constant = whitespaceSize + (CGFloat(nestedLevel) * indentationWidth)
        leadingAnchorConstraint.constant = constant
        separatorInset = UIEdgeInsets(top: 0, left: constant, bottom: 0, right: 0)
    }

    private func setupViews() {
        addSubview(stack)
        stack.addArrangedSubview(metadataStack)
        stack.addArrangedSubview(comment)
        metadataStack.addArrangedSubview(username)
        metadataStack.addArrangedSubview(timestamp)
    }

    private func setupConstraints() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        bottomAnchorConstraint.priority = .fittingSizeLevel
        NSLayoutConstraint.activate(stackConstraints)

        stack.spacing = whitespaceSize
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = UITableViewCell.SelectionStyle.none

        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
