//
//  CoinCard.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/2/24.
//

import SwiftUI

struct CoinCard: View {
    /// View properties
    @StateObject private var viewModel: CoinCard.ViewModel /// ViewModel
    @State private var showDetails: Bool = false /// Bool to control the visibility of the details
    
    var coin: Coin /// The coin to be displayed
    private let geckoService: GeckoService /// Service to fetch additional data as needed
    
    /// Init
    init(coin: Coin, geckoService: GeckoService) {
        self.coin = coin
        self.geckoService = geckoService
        _viewModel = StateObject(wrappedValue: CoinCard.ViewModel(geckoService: geckoService, coinID: coin.id))
    }
    
    var body: some View {
        HStack {
            /// SwiftUI's AyncImage saves so much boilerplate
            AsyncImage(url: URL(string: coin.image)) { phase in
                if let image = phase.image { /// if image loaded successfully
                    image.resizable()
                         .scaledToFit()
                         .frame(width: 20, height: 20)
                } else if phase.error != nil { /// couldn't load image
                    VStack {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(.red)
                        
                        Text("Couldn't Load \nImage")
                            .font(.caption2)
                            .multilineTextAlignment(.center)
                    }
                } else { /// while loading show ProgressView
                    ProgressView()
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.leading, 5)
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
                /// Coin current price
                Text("$\(coin.current_price, specifier: "%0.2f")")
                    .font(Font.custom("MontserratRoman-Medium", size: 16))
                
                /// Coin price change percentage
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
            
        }
        .fullScreenCover(isPresented: $showDetails) {
            CardDetails(viewModel: viewModel, showDetails: $showDetails, coinID: coin.id)
        }
    }
}

#Preview {
    CoinCard(coin: Coin(), geckoService: MockGeckoService())
}
