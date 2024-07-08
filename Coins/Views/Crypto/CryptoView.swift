//
//  CryptoMainView.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/1/24.
//

import SwiftUI

struct CryptoView: View {
    @StateObject private var viewModel: CryptoView.ViewModel = CryptoView.ViewModel()
    
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
                        .font(Font.custom("MontserratRoman-Bold", size: 28))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // MARK: Featured section
                    VStack {
                        Text("Featured")
                            .font(Font.custom("MontserratRoman-Bold", size: 28))
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
                .searchable(text: $searchRequest)
            }
        }
        .task {
            viewModel.fetchTopCoins(limit: 5)
        }
    }
}

#Preview {
    CryptoView()
}
