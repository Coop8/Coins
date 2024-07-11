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
            }
            
            Spacer()
            
            VStack {
                Text("$\(coin.current_price, specifier: "%0.2f")")
                    .font(Font.custom("MontserratRoman-Medium", size: 16))
                
                HStack(spacing: 2) {
                    Text(coin.price_change_24h.isLess(than: 0) ? "-" : "+")
                        .font(Font.custom("MontserratRoman-Medium", size: 14))

                    Text("\(coin.price_change_24h.magnitude, specifier: "%0.2f")")
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
            Button {
                showDetails.toggle()
            } label: {
                Image(systemName: "xmark.circle.fill")
            }
            .task {
                viewModel.fetchHistoricalData(for: coin.id, timeRange: .twentyFourHours)
            }

//            HStack {
//                Button {
//                } label: {
//                    Text("Day")
//                }
//                
//                Button {
//                } label: {
//                    Text("Month")
//                }
//                
//                Button {
//                } label: {
//                    Text("Year")
//                }
//            }
            
            if let marketData = viewModel.marketData {
                ScrollView {
                    ForEach(marketData.prices, id: \.self) { price in
                        HStack {
                            Text("Timestamp: \(Date(unixTimestamp: price[0]), formatter: DateFormatter.customFormatter)")
                            Spacer()
                            Text("Price: \(price[1], specifier: "%.2f")")
                        }
                    }
                }
            }
        }
    }
}

extension DateFormatter {
    static let customFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

extension Date {
    init(unixTimestamp: Double) {
        self.init(timeIntervalSince1970: unixTimestamp / 1000.0)
    }
}

#Preview {
    CoinCard(coin: Coin())
}
