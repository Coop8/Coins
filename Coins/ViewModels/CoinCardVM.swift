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
        @Published var dailyPriceChangePercentage: Double = 0.0

        private var gecko = Gecko()

        /// Fetch detailed coin data for a coin given the coinID
        func fetchCoinData(for coinID: String) {
            isLoading = true
            gecko.fetchCoinDetails(for: coinID) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let coinDetails):
                        self?.dailyPriceChangePercentage = coinDetails.market_data.price_change_percentage_24h
                    case .failure(let error):
                        print("Error fetching coin data: \(error)")
                    }
                    self?.isLoading = false
                }
            }
        }
    }
}
