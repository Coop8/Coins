//
//  ContentViewVM.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/1/24.
//

import Foundation
import Combine

extension MainView {
    final class ViewModel: ObservableObject {
        @Published var isLoading: Bool = false
        @Published var coinName: String = ""
        @Published var coinPrice: Double = 0.0
        @Published var dailyPriceChangePercentage: Double = 0.0
        
        private var api = CGNetworkHandler()
        private var cancellables = Set<AnyCancellable>()
        
        func fetchCoinData(for coinID: String) {
            isLoading = true
            api.fetchCoinData(for: coinID) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let coin):
                        self?.coinName = coin.name
                        self?.coinPrice = coin.market_data.current_price["usd"] ?? 0.0
                        self?.dailyPriceChangePercentage = coin.market_data.price_change_percentage_24h
                    case .failure(let error):
                        print("Error fetching coin data: \(error)")
                    }
                    self?.isLoading = false
                }
            }
        }
    }
}
