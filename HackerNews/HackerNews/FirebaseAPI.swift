//
//  FirebaseAPI.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 5/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class FirebaseAPI: Firebasable {
    var requestable: Requestable
    let queryable: Queryable

    func call() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        queryable.topStoryQuery { snap in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false

            guard let ids = snap?.value as? [Int] else { return }
            self.requestable.setData([HackerNewsItem](repeating: HackerNewsItem.Empty, count: ids.count))

            for id in ids {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                self.queryable.itemQuery(id) { snap in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false

                    guard let newsItem = HackerNewsItem(data: snap!) else { return }
                    let index = ids.firstIndex(of: id)!
                    self.requestable.setData(at: index, with: newsItem)
                }
            }
        }
    }

    func call(_ id: Int) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        queryable.itemQuery(id) { snap in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false

            guard let item = HackerNewsItem(data: snap!) else { return }
            self.request(ids: item.kids)
        }
    }

    private func request(ids: [Int]?) {
        guard let ids = ids else { return }
        guard !ids.isEmpty else { return }

        var commentsMap = [Int: HackerNewsFirebaseComment]()

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        for id in ids {
            queryable.itemQuery(id) { snap in

                commentsMap[id] = HackerNewsFirebaseComment(data: snap!) ?? HackerNewsFirebaseComment.Empty(0)

                guard commentsMap.count == ids.count else { return }

                var sortedComments = [HackerNewsFirebaseComment]()
                for id in ids {
                    let comment = commentsMap[id] ?? HackerNewsFirebaseComment.Empty(0)
                    sortedComments.append(comment)
                    self.request(ids: comment.kids)
                }

                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.requestable.setData(sortedComments)
            }
        }
    }

    init(_ requestable: Requestable, _ queryable: Queryable = AppDelegate.firebaseQuery()) {
        self.requestable = requestable
        self.queryable = queryable
    }
}
