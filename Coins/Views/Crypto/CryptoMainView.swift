//
//  CryptoMainView.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/1/24.
//

import SwiftUI

struct CryptoMainView: View {
    @StateObject private var viewModel: CryptoMainView.ViewModel = CryptoMainView.ViewModel()
    
    // View properties
    @State private var searchRequest: String = ""
    
    private var searchResults: [Coin] {
        if searchRequest.isEmpty {
            return viewModel.topCoins
        } else {
            return viewModel.topCoins.filter { $0.name.contains(searchRequest) }
        }
    }
    
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else {
                // MARK: Favorites section
                Text("Favorites")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                List {
                    // MARK: Featured section
                    Text("Featured")
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ForEach(searchResults, id: \.self) { coin in
                        CoinCard(coin: coin)
                    }
                }
            }
        }
        .task {
            viewModel.fetchTopCoins(limit: 10)
        }
    }
}

#Preview {
    CryptoMainView()
}
