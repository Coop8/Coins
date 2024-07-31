//
//  GeckoService.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/13/24.
//

import Foundation

protocol GeckoService {
    func fetchTopCoins(limit: Int, completion: @escaping (Result<[Coin], Gecko.APIError>) -> Void)
    func fetchHistoricalData(for coinID: String, from startTimestamp: Int, to endTimestamp: Int, completion: @escaping (Result<Coin.details.MarketData, Gecko.APIError>) -> Void)
}
