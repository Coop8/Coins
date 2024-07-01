//
//  Coin.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/1/24.
//

import Foundation

final class Coin: Decodable {
    let id: String
    let symbol: String
    let name: String
    let market_data: MarketData
    
    struct MarketData: Decodable {
        let current_price: [String: Double]
        let price_change_percentage_24h: Double
    }
}
