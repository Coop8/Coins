//
//  CoinCard.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/2/24.
//

import SwiftUI

struct CoinCard: View {
    @StateObject private var viewModel: CoinCard.ViewModel
    @State private var showDetails: Bool = false
    
    var coin: Coin
    private let geckoService: GeckoService
    
    init(coin: Coin, geckoService: GeckoService) {
        self.coin = coin
        self.geckoService = geckoService
        _viewModel = StateObject(wrappedValue: CoinCard.ViewModel(geckoService: geckoService))
    }
    
    var body: some View {
        HStack {
            /// SwiftUI's AyncImage saves so much boilerplate
            AsyncImage(url: URL(string: coin.image)) { phase in
                if let image = phase.image {
                    image.resizable()
                         .scaledToFit()
                         .frame(width: 20, height: 20)
                } else if phase.error != nil {
                    VStack {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        
                        Text("Couldn't Load Image")
                            .font(.caption2)
                            .multilineTextAlignment(.center)
                    }
                } else {
                    ProgressView()
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.trailing, 10)

            VStack {
                Text(coin.name)
                    .font(Font.custom("MontserratRoman-Bold", size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("\(coin.symbol.uppercased())")
                    .font(Font.custom("MontserratRoman-SemiBold", size: 18))
                    .opacity(0.6)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("$\(coin.current_price, specifier: "%0.2f")")
                    .font(Font.custom("MontserratRoman-Medium", size: 16))
                
                HStack(spacing: 2) {
                    Text(coin.price_change_percentage_24h.isLess(than: 0) ? "-" : "+")
                        .font(Font.custom("MontserratRoman-Medium", size: 14))

                    Text("\(coin.price_change_percentage_24h.magnitude, specifier: "%0.2f")%")
                        .font(Font.custom("MontserratRoman-Medium", size: 14))
                }                        
                .foregroundStyle(coin.price_change_24h.isLess(than: 0) ? .red : .green)

            }
        }
        .frame(maxWidth: .infinity, maxHeight: 75)
        .onTapGesture {
            showDetails.toggle()
            viewModel.fetchHistoricalData(for: coin.id, timeRange: .oneHour)
        }
        .fullScreenCover(isPresented: $showDetails) {
            CardDetails(viewModel: viewModel, showDetails: $showDetails)
        }
    }
}

#Preview {
    CoinCard(coin: Coin(), geckoService: Gecko())
}
