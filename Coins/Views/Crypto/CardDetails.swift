//
//  CardDetails.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/13/24.
//

import SwiftUI
import Charts

struct CardDetails: View {
    @ObservedObject var viewModel: CoinCard.ViewModel
    @Binding var showDetails: Bool
    
    var body: some View {
        Button {
            showDetails.toggle()
        } label: {
            Image(systemName: "xmark.circle.fill")
        }
        
        if let marketData = viewModel.marketData {
            ScrollView {
                Chart {
                    ForEach(marketData.prices, id: \.self) { point in
                        let date = Date(unixTimestamp: point[0])
                        LineMark(
                            x: .value("Time", date),
                            y: .value("Price", point[1])
                        )
                        .interpolationMethod(.catmullRom)
                    }
                }
                .chartYScale(domain: viewModel.priceDomain!.min...viewModel.priceDomain!.max)
                .frame(height: 300)
                .padding()
            }
        }
    }
}

extension Date {
    init(unixTimestamp: Double) {
        self.init(timeIntervalSince1970: unixTimestamp / 1000.0)
    }
}

#Preview {
    CardDetails(viewModel: CoinCard.ViewModel(), showDetails: .constant(true))
}
