//
//  CryptoMainView.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/1/24.
//

import SwiftUI

struct CryptoMainView: View {
    @StateObject var viewModel: CryptoMainView.ViewModel
    
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
                ScrollView {
                    ForEach(searchResults, id: \.self) { coin in
                        HStack {
                            CoinCard(viewModel: CoinCard.ViewModel(), coin: coin)
                        }
                    }
                }
                .searchable(text: $searchRequest)
            }
        }
        .onAppear {
            viewModel.fetchTopCoins(limit: 50)
        }
    }
}

#Preview {
    CryptoMainView(viewModel: CryptoMainView.ViewModel())
}
