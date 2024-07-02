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
    let current_price: Double
    let price_change_24h: Double
    let price_change_percentage_24h: Double
}

extension Coin {
    class details: Decodable {
        let market_data: MarketData
        
        struct MarketData: Decodable {
            let current_price: [String: Double]
            let price_change_percentage_24h: Double
        }
    }
}

extension Coin: Hashable {
    static func == (lhs: Coin, rhs: Coin) -> Bool {
        return lhs.id.lowercased() == rhs.id.lowercased()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(symbol)
    }
}
