//
//  Date.swift
//  Coins
//
//  Created by Cooper Rockwell on 8/1/24.
//

import Foundation

/// Extension to initialize a date from a Unix timestamp
extension Date {
    init(unixTimestamp: Double) {
        self.init(timeIntervalSince1970: unixTimestamp / 1000.0)
    }
}
