//
//  MainViewController.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 29/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class MainViewController: UINavigationController {
    let newsItemsVC = NewsItemsViewController()

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        return searchBar
    }()

    func push(to detailViewController: UIViewController) {
        searchBar.isHidden = true
        pushViewController(detailViewController, animated: true)
    }

    private func setupViews() {
        navigationBar.addSubview(searchBar)
        searchBar.constrain(to: navigationBar, margin: 5)

        navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        pushViewController(newsItemsVC, animated: false)
    }
}

extension MainViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        newsItemsVC.newsItemFilter = searchBar.text ?? ""
    }
}

extension MainViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        newsItemsVC.newsItemFilter = searchBar.text ?? ""
    }
}
