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
        @Published var marketData: [TimeRange: Coin.details.MarketData] = [:]
        @Published var selectedTimeRange: TimeRange = .oneHour {
            didSet {
                if marketData[selectedTimeRange] == nil {
                    fetchHistoricalData(for: coinID, timeRange: selectedTimeRange)
                } else {
                    updatePriceDomain()
                }
            }
        }
        @Published var priceDomain: (min: Double, max: Double)?

        private var geckoService: GeckoService
        private var coinID: String

        /// Init
        init(geckoService: GeckoService = Gecko(), coinID: String) {
            self.geckoService = geckoService
            self.coinID = coinID
            fetchHistoricalData(for: coinID, timeRange: .oneHour) // Initial data load
        }

        /// Fetch the chart market data
        func fetchHistoricalData(for coinID: String, timeRange: TimeRange) {
            isLoading = true
            let dateRange = timeRange.dateRange
            geckoService.fetchHistoricalData(for: coinID, from: dateRange.start, to: dateRange.end) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let marketData):
                        self?.marketData[timeRange] = marketData
                        self?.updatePriceDomain()
                    case .failure(let error):
                        print("Error fetching market data: \(error)")
                    }
                }
            }
        }

        /// Calculate the domain of the prices
        func updatePriceDomain() {
            guard let data = marketData[selectedTimeRange] else { return }
            let prices = data.prices.map { $0[1] }
            if let minPrice = prices.min(), let maxPrice = prices.max() {
                self.priceDomain = (min: minPrice, max: maxPrice)
            } else {
                self.priceDomain = nil
            }
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
