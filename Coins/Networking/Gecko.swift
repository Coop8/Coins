//
//  CGNetworkHandler.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/1/24.
//

import Foundation

final class Gecko {
    private let baseURL = "https://api.coingecko.com/api/v3"
        
    enum APIError: Error {
        case invalidURL
        case networkProblem
        case invalidResponse
        case httpError(Int)
        case responseProblem
        case decodingProblem
        case encodingProblem
    }

    func fetchCoinDetails(for coinID: String, completion: @escaping (Result<Coin.details, APIError>) -> Void) {
        let endpoint = "/coins/\(coinID)?localization=false&community_data=false&developer_data=false?x_cg_demo_api_key=\(APIKeys.coinGeckoAPIKey)"
        guard let url = URL(string: baseURL + endpoint) else { return }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let jsonData = data else {
                completion(.failure(.responseProblem))
                return
            }
            
            do {
                let coinDetails = try JSONDecoder().decode(Coin.details.self, from: jsonData)
                completion(.success(coinDetails))
            } catch {
                completion(.failure(.decodingProblem))
            }
        }
        dataTask.resume()
    }
    
    func fetchTopCoins(limit: Int, completion: @escaping (Result<[Coin], APIError>) -> Void) {
        let endpoint = "/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=\(limit)&page=1?x_cg_demo_api_key=\(APIKeys.coinGeckoAPIKey)"
        guard let url = URL(string: baseURL + endpoint) else {
                print("Error: Invalid URL.")
                completion(.failure(.invalidURL))
                return
            }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network Error: \(error.localizedDescription)")
                completion(.failure(.networkProblem))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Invalid response received from the server.")
                completion(.failure(.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP Error: Status code \(httpResponse.statusCode)")
                completion(.failure(.httpError(httpResponse.statusCode)))
                return
            }
            
            guard let jsonData = data else {
                print("Error: No data received from the server.")
                completion(.failure(.responseProblem))
                return
            }
            
            do {
                let coins = try JSONDecoder().decode([Coin].self, from: jsonData)
                completion(.success(coins))
            } catch let decodingError {
                print("Decoding Error: \(decodingError.localizedDescription)")
                completion(.failure(.decodingProblem))
            }
        }
        dataTask.resume()
    }
}
