//
//  ContentView.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/1/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainView.ViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else {
                Text("Coin: \(viewModel.coinName)")
                Text("Price: \(viewModel.coinPrice, specifier: "%.2f") USD")
                Text("Daily Change: \(viewModel.dailyPriceChangePercentage, specifier: "%.2f")%")
            }
        }
        .onAppear {
            viewModel.fetchCoinData(for: "bitcoin")
        }
    }
}

#Preview {
    MainView(viewModel: MainView.ViewModel())
}
