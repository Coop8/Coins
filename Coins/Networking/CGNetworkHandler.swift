//
//  CGNetworkHandler.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/1/24.
//

import Foundation

final class CGNetworkHandler {
    private let baseURL = "https://api.coingecko.com/api/v3"
        
    enum APIError: Error {
        case responseProblem
        case decodingProblem
        case encodingProblem
    }

    func fetchCoinData(for coinID: String, completion: @escaping (Result<Coin, APIError>) -> Void) {
        let endpoint = "/coins/\(coinID)?localization=false&community_data=false&developer_data=false"
        guard let url = URL(string: baseURL + endpoint) else { return }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(APIKeys.coinGeckoAPIKey, forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let jsonData = data else {
                completion(.failure(.responseProblem))
                return
            }
            
            do {
                let coin = try JSONDecoder().decode(Coin.self, from: jsonData)
                completion(.success(coin))
            } catch {
                completion(.failure(.decodingProblem))
            }
        }
        dataTask.resume()
    }
}
