//
//  CoinCard.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/2/24.
//

import SwiftUI

struct CoinCard: View {
    @StateObject private var viewModel: CoinCard.ViewModel = CoinCard.ViewModel()
    @State private var showDetails: Bool = false
    
    var coin: Coin
    
    var body: some View {
        HStack {
            HStack {
                /// SwiftUI's AyncImage saves so much boilerplate
                AsyncImage(url: URL(string: coin.image)) { phase in
                    if let image = phase.image {
                        image.resizable()
                             .scaledToFit()
                             .frame(width: 50, height: 50)
                    } else if phase.error != nil {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    } else {
                        ProgressView()
                            .frame(width: 50, height: 50)
                    }
                }
                .padding(.trailing, 10)
                
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
                .task {
                    viewModel.fetchCoinData(for: coin.id)
                }
        }
    }
}

#Preview {
    CoinCard(coin: Coin())
}
