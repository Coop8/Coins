//
//  MainView.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/1/24.
//

import SwiftUI

struct MainView: View {
    private let gecko: GeckoService = Gecko()
    
    var body: some View {
        ZStack {
            TabView {
                CryptoView(geckoService: gecko)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tabItem {
                        Text("Crypto")
                        Image(systemName: "coloncurrencysign.circle.fill")
                    }
                
                StocksView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tabItem {
                        Text("Stocks")
                        Image(systemName: "chart.line.uptrend.xyaxis")
                    }
                
                SettingsView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tabItem {
                        Text("Settings")
                        Image(systemName: "slider.horizontal.3")
                    }
            }
        }
    }
}

#Preview {
    MainView()
}
