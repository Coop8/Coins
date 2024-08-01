//
//  CardDetails.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/13/24.
//

import SwiftUI
import Charts

struct CardDetails: View {
    /// View properties
    @ObservedObject var viewModel: CoinCard.ViewModel /// ViewModel
    @Binding var showDetails: Bool /// Bool to control visibility of the details
    
    let coinID: String /// ID of the coin being displayed

    /// Init
    init(viewModel: CoinCard.ViewModel, showDetails: Binding<Bool>, coinID: String) {
        self.coinID = coinID
        self._showDetails = showDetails
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color.themeBackground.ignoresSafeArea() /// Background color
            
            /// While loading show ProgressView
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5))
                    .edgesIgnoringSafeArea(.all)
            } else {
                VStack {
                    /// Button to close details
                    Button {
                        showDetails.toggle()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.themeSecondary.opacity(0.4))
                    }

                    /// Time range buttons
                    HStack {
                        Button("1H") { viewModel.selectedTimeRange = .oneHour }
                        Button("24H") { viewModel.selectedTimeRange = .twentyFourHours }
                        Button("1M") { viewModel.selectedTimeRange = .oneMonth }
                        Button("1Y") { viewModel.selectedTimeRange = .oneYear }
                    }

                    /// Display market data in chart if possible
                    if let marketData = viewModel.marketData[viewModel.selectedTimeRange] {
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
                            .clipped() /// Ensure no clipping issues
                        }
                        .frame(maxWidth: .infinity, maxHeight: 500)
                        .background(.ultraThinMaterial)
                    }
                }
            }
        }
    }
}

#Preview {
    CardDetails(viewModel: CoinCard.ViewModel(geckoService: MockGeckoService(), coinID: "bitcoin"), showDetails: .constant(true), coinID: "bitcoin")
}
