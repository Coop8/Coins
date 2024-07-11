//
//  CGNetworkHandler.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/1/24.
//

import Foundation

final class Gecko {
    private let baseURL = "https://api.coingecko.com/api/v3"
    
    /// Custom errors for API operations
    enum APIError: Error {
        case invalidURL
        case networkProblem
        case invalidResponse
        case httpError(Int)
        case responseProblem
        case decodingProblem
        case encodingProblem
    }
        
    /// Fetches the top coins from the CoinGecko API
    func fetchTopCoins(limit: Int, completion: @escaping (Result<[Coin], APIError>) -> Void) {
        let endpoint = "/coins/markets"
        
        /// Query parameters for the API request
        let queryItems = [
            URLQueryItem(name: "vs_currency", value: "usd"),
            URLQueryItem(name: "order", value: "market_cap_desc"),
            URLQueryItem(name: "per_page", value: "\(limit)"),
            URLQueryItem(name: "page", value: "1")
        ]
        
        /// Constructing the URL for the request
        guard var urlComponents = URLComponents(string: baseURL + endpoint) else {
            print("Error: Invalid URL components.")
            completion(.failure(.invalidURL))
            return
        }
        
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            print("Error: Failed to create URL.")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        /// Perform the request
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
    
    /// Fetches historical market data for a specific coin and time range
    func fetchHistoricalData(for coinID: String, from startTimestamp: Int, to endTimestamp: Int, completion: @escaping (Result<Coin.details.MarketData, APIError>) -> Void) {
        let endpoint = "/coins/\(coinID)/market_chart/range"
        
        /// Query parameters for the API request
        let queryItems = [
            URLQueryItem(name: "vs_currency", value: "usd"),
            URLQueryItem(name: "from", value: "\(startTimestamp)"),
            URLQueryItem(name: "to", value: "\(endTimestamp)")
        ]
        
        /// Constructing the URL for the request
        guard var urlComponents = URLComponents(string: baseURL + endpoint) else {
            print("Error: Invalid URL components.")
            completion(.failure(.invalidURL))
            return
        }
        
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            print("Error: Failed to create URL.")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "x-cg-demo-api-key": APIKeys.coinGeckoAPIKey
        ]
        
        /// Performing the request
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
                let marketData = try JSONDecoder().decode(Coin.details.MarketData.self, from: jsonData)
                completion(.success(marketData))
            } catch let decodingError {
                print("Decoding Error: \(decodingError.localizedDescription)")
                completion(.failure(.decodingProblem))
            }
        }
        dataTask.resume()
    }
}
