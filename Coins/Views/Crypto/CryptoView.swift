//
//  CryptoView.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/1/24.
//

import SwiftUI

struct CryptoView: View {
    /// View properties
    @StateObject private var viewModel: CryptoView.ViewModel /// ViewModel
    private let geckoService: GeckoService /// Service to fetch additional data as needed
    
    /// Init
    init(geckoService: GeckoService) {
        self.geckoService = geckoService
        _viewModel = StateObject(wrappedValue: CryptoView.ViewModel(geckoService: geckoService))
    }
    
    var body: some View {
        ZStack {
            Color.themeBackground.ignoresSafeArea() /// Background color
            
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else {
                ScrollView {
                    // MARK: Favorites section
                    VStack {
                        Text("Favorites")
                            .bold()
                            .font(.title)
                            .foregroundStyle(.themeTertiary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if viewModel.favoriteCoins.isEmpty {
                            Text("Favorite some coins to view them here!")
                                .font(Font.custom("MontserratRoman-Regular", size: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            ForEach(viewModel.favoriteCoins, id: \.self) { coin in
                                CoinCard(coin: coin, geckoService: geckoService)
                                
                                /// Add a divider if the element is not last in the array
                                if coin != viewModel.favoriteCoins.last {
                                    Divider()
                                }
                            }
                        }
                    }
                    
                    // MARK: Featured section
                    VStack {
                        Text("Featured")
                            .bold()
                            .font(.title)
                            .foregroundStyle(.themeTertiary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack {
                            if viewModel.topCoins.isEmpty {
                                Text("No featured coins available. Check your network.")
                            } else {
                                ForEach(viewModel.topCoins, id: \.self) { coin in
                                    CoinCard(coin: coin, geckoService: geckoService)
                                    
                                    /// Add a divider if the element is not last in the array
                                    if coin != viewModel.topCoins.last {
                                        Divider()
                                    }
                                }
                            }
                        }
                        .padding(10)
                        .background(.themePrimary, in: .rect(cornerRadius: 10))
                    }
                }
                .padding(.horizontal)
            }
        }
        .task {
            viewModel.fetchTopCoins(limit: 5)
        }
    }
}

#Preview {
    CryptoView(geckoService: MockGeckoService())
}
