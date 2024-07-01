//
//  CoinsApp.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/1/24.
//

import SwiftUI

@main
struct CoinsApp: App {
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainView.ViewModel())
        }
    }
}
