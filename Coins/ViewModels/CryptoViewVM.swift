//
//  ContentViewVM.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/1/24.
//

import Foundation
import Combine

extension CryptoView {
    final class ViewModel: ObservableObject {
        @Published var isLoading: Bool = false
        @Published var topCoins: [Coin] = []
        @Published var favoriteCoins: [Coin] = []
        
        private var gecko = Gecko()
        
        func fetchTopCoins(limit: Int) {
            isLoading = true
            gecko.fetchTopCoins(limit: limit) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let coins):
                        self?.topCoins = coins
                    case .failure(let error):
                        print("Error fetching top coins: \(error)")
                    }
                    self?.isLoading = false
                }
            }
        }
    }
}
