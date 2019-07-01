//
//  Date+timeSince.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 30/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

extension Date {
    static func time(since fromDate: Date) -> String {
        guard fromDate < Date() else { return "Back to the future" }

        let allComponents: Set<Calendar.Component> = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components:DateComponents = Calendar.current.dateComponents(allComponents, from: fromDate, to: Date())

        for (period, timeAgo) in [
            ("year", components.year ?? 0),
            ("month", components.month ?? 0),
            ("week", components.weekOfYear ?? 0),
            ("day", components.day ?? 0),
            ("hour", components.hour ?? 0),
            ("minute", components.minute ?? 0),
            ("second", components.second ?? 0),
            ] {
                if timeAgo > 0 {
                    return "\(timeAgo.of(period)) ago"
                }
        }

        return "Just now"
    }
}
