//
//  StyledCellLabel.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 28/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class StyledCellLabel: UILabel {
    var textContent: String = " " {
        didSet {
            placeHolderColor = textContent == " " ? placeHolderColor : .white
            backgroundColor = placeHolderColor
            text = textContent
            accessibilityLabel = textContent
        }
    }

    var placeHolderColor: UIColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = placeHolderColor
        text = textContent
        accessibilityLabel = textContent
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
