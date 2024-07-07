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
                ScrollView {
                    // MARK: Favorites section
                    Text("Favorites")
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // MARK: Featured section
                    VStack {
                        Text("Featured")
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack {
                            ForEach(viewModel.topCoins, id: \.self) { coin in
                                CoinCard(coin: coin)
                                /// Add a divider if the element is not last in the array
                                if coin != viewModel.topCoins.last {
                                    Divider()
                                }
                            }
                        }
                        .padding(10)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.horizontal)
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
