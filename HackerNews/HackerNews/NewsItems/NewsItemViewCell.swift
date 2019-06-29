//
//  NewsItemViewCell.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 27/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class NewsItemViewCell: UITableViewCell {
    private let whitespaceSize: CGFloat = 10

    var titleText: String = " " {
        didSet { title.textContent = titleText }
    }
    var commentText: String = " " {
        didSet { comment.textContent = commentText }
    }

    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()

    lazy var title: StyledCellLabel = {
        let label = StyledCellLabel()
        label.textContent = titleText
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()

    lazy var comment: StyledCellLabel = {
        let label = StyledCellLabel()
        label.textContent = commentText
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()

    private func setupViews() {
        addSubview(stack)
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(comment)
    }

    private func setupConstraints() {
        stack.constrain(to: self, margin: whitespaceSize)
        stack.spacing = whitespaceSize
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = UITableViewCell.SelectionStyle.none
        separatorInset = UIEdgeInsets(top: 0, left: whitespaceSize, bottom: 0, right: 0)

        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
