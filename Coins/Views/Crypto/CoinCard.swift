//
//  CoinCard.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/2/24.
//

import SwiftUI

struct CoinCard: View {
    @StateObject var viewModel: CoinCard.ViewModel
    @State private var showDetails: Bool = false
    
    var coin: Coin
    
    var body: some View {
        HStack {
            HStack {
                Text(coin.name)
                    .font(.title2)
                    .bold()
                Text("(\(coin.symbol.uppercased()))")
                    .opacity(0.6)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            VStack {
                Text("$\(coin.current_price, specifier: "%0.2f")")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Text("\(coin.price_change_24h, specifier: "%0.2f") (\(coin.price_change_percentage_24h, specifier: "%0.3f")%)")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.subheadline)
                    .foregroundStyle(coin.price_change_24h.isLess(than: 0) ? .red : .green)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .frame(maxWidth: .infinity, maxHeight: 75)
        .onTapGesture {
            viewModel.fetchCoinData(for: coin.id)
            showDetails.toggle()
        }
        .fullScreenCover(isPresented: $showDetails) {
            Button {
                showDetails.toggle()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.accent)
            }
            Text("\(viewModel.dailyPriceChangePercentage, specifier: "%0.3f")")
        }
    }
}

#Preview {
    CoinCard(viewModel: CoinCard.ViewModel(), coin: Coin())
}
