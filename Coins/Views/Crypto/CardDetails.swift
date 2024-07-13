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
    
    let coinID: String
    
    init(viewModel: CoinCard.ViewModel, showDetails: Binding<Bool>, coinID: String) {
        self.coinID = coinID
        self._showDetails = showDetails
        self.viewModel = viewModel
    }
    
    var body: some View {
        Button {
            showDetails.toggle()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundStyle(.white.opacity(0.2))
        }
        
        if let marketData = viewModel.marketData {
            VStack {
                Chart {
                    ForEach(marketData.prices, id: \.self) { point in
                        let date = Date(unixTimestamp: point[0])
                        let price = point[1]
                        
                        LineMark(
                            x: .value("Time", date, unit: .minute),
                            y: .value("Price", price)
                        )
                        .interpolationMethod(.monotone)
                        .foregroundStyle(.themeSecondary)
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        
                        AreaMark(
                            x: .value("Time", date, unit: .minute),
                            y: .value("Price", price)
                        )
                        .interpolationMethod(.monotone)
                        .foregroundStyle(.themeSecondary.opacity(0.3))
                    }
                }
                .chartYScale(domain: viewModel.priceDomain!.min...viewModel.priceDomain!.max)
                .frame(height: 300)
                .padding()
                .clipped() // Ensure no clipping issues
            }
            .frame(maxWidth: .infinity, maxHeight: 500)
            .background(.ultraThinMaterial)
        }
    }
}

extension Date {
    init(unixTimestamp: Double) {
        self.init(timeIntervalSince1970: unixTimestamp / 1000.0)
    }
}

#Preview {
    CardDetails(viewModel: CoinCard.ViewModel(), showDetails: .constant(true), coinID: "bitcoin")
}
