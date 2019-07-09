//
//  String+html.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 4/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        do {
            return try NSAttributedString(data: data, options: options, documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }

    var htmlToString: String {
        return htmlToAttributedString?.string ?? self
    }
}
