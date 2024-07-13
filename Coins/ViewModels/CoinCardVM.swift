//
//  CoinCardVM.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/2/24.
//

import Foundation
import Combine

extension CoinCard {
    final class ViewModel: ObservableObject {
        @Published var isLoading: Bool = false
        @Published var marketData: Coin.details.MarketData? {
            didSet {
                priceDomain = calculatePriceDomain()
            }
        }
        @Published var selectedTimeRange: TimeRange = .oneHour {
            didSet {
                fetchHistoricalData(for: "bitcoin", timeRange: selectedTimeRange)
            }
        }
        @Published var priceDomain: (min: Double, max: Double)?
        
        private var gecko = Gecko()
        
        /// Fetch the chart market data
        func fetchHistoricalData(for coinID: String, timeRange: TimeRange) {
            let dateRange = timeRange.dateRange
            gecko.fetchHistoricalData(for: coinID, from: dateRange.start, to: dateRange.end) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let marketData):
                        self?.marketData = marketData
                    case .failure(let error):
                        print("Error fetching market data: \(error)")
                    }
                }
            }
        }
        
        /// Calculate the domain of the prices
        func calculatePriceDomain() -> (min: Double, max: Double)? {
            guard let prices = marketData?.prices else { return nil }
            
            let priceDomain = prices.map { $0[1] }
            
            guard let minPrice = priceDomain.min(),
                  let maxPrice = priceDomain.max() else { return nil }
            
            return (min: minPrice, max: maxPrice)
        }
    }
}

/// Time range extension to give the option for chart data
enum TimeRange {
    case oneHour
    case twentyFourHours
    case oneMonth
    case oneYear

    var dateRange: (start: Int, end: Int) {
        let end = Int(Date().timeIntervalSince1970)
        let start: Int
        switch self {
        case .oneHour:
            start = end - 3600 // 3600 seconds in 1 hour
        case .twentyFourHours:
            start = end - 86400 // 86400 seconds in 24 hours
        case .oneMonth:
            start = end - 2592000 // 2592000 seconds in 30 days (approx)
        case .oneYear:
            start = end - 31536000 // 31536000 seconds in 365 days (approx)
        }
        return (start, end)
    }
}
