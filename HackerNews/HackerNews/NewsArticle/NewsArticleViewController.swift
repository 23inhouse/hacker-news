//
//  NewsArticleViewController.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 10/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit
import SafariServices

class NewsArticleViewController: SFSafariViewController {
    private lazy var navigationBar: UIView? = {
        guard let navigationController = navigationController as? MainViewController else { return nil }
        return navigationController.navigationBar
    }()

    override func viewWillAppear(_ animated: Bool) {
        navigationBar?.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationBar?.isHidden = false
    }

    init(_ url: URL) {
        let configuration = Configuration()
        configuration.entersReaderIfAvailable = true

        super.init(url: url, configuration: configuration)
    }
}
