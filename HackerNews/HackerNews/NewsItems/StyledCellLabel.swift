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
        didSet { setText(self, textContent) }
    }

    var attributedContent: NSAttributedString = NSAttributedString(string: " ") {
        didSet { setAttributed(self, attributedContent) }
    }

    var setText: (StyledCellLabel, String) -> Void = { (self, textContent) in
        self.placeHolderColor = textContent == " " ? self.placeHolderColor : .white
        self.backgroundColor = self.placeHolderColor
        self.text = textContent
        self.accessibilityLabel = textContent
    }

    var setAttributed: (StyledCellLabel, NSAttributedString) -> Void = { (self, textContent) in
        self.placeHolderColor = textContent == NSAttributedString(string: " ") ? self.placeHolderColor : .white
        self.backgroundColor = self.placeHolderColor
        self.attributedText = textContent
        self.accessibilityLabel = textContent.string
    }

    var placeHolderColor: UIColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        attributedContent.length > 0
            ? setAttributed(self, attributedContent)
            : setText(self, textContent)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
