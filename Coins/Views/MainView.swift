//
//  ContentView.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/1/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.themeBackground.ignoresSafeArea()
                TabView {
                    CryptoView()
                        .tabItem {
                            Text("Crypto")
                        }
                    
                    StocksView()
                        .tabItem {
                            Text("Stocks")
                            Image(systemName: "chart.line.uptrend.xyaxis")
                        }
                    
                    SettingsView()
                        .tabItem {
                            Text("Settings")
                            Image(systemName: "slider.horizontal.3")
                        }
                }
            }
        }
    }
}

#Preview {
    MainView()
}
