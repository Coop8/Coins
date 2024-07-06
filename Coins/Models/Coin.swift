//
//  Coin.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/1/24.
//

import Foundation

final class Coin: Decodable, ObservableObject {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let current_price: Double
    let price_change_24h: Double
    let price_change_percentage_24h: Double
    
    init() {
        self.id = "bitcoin"
        self.symbol = "btc"
        self.name = "Bitcoin"
        self.image = "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400"
        self.current_price = 61982.70
        self.price_change_24h = -847.40
        self.price_change_percentage_24h = -1.35
    }
}

extension Coin {
    class details: Decodable {
        let market_data: MarketData
        
        struct MarketData: Decodable {
            let price_change_24h: Double
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

extension Coin {
    static var exampleCoin: Coin {
        return .init()
    }
}
