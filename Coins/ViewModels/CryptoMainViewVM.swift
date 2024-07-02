//
//  ContentViewVM.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/1/24.
//

import Foundation
import Combine

extension CryptoMainView {
    final class ViewModel: ObservableObject {
        @Published var isLoading: Bool = false
        @Published var topCoins: [Coin] = []
        
        private var api = CGNetworkHandler()
        private var cancellables = Set<AnyCancellable>()
        
        func fetchTopCoins(limit: Int) {
            isLoading = true
            api.fetchTopCoins(limit: limit) { [weak self] result in
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
