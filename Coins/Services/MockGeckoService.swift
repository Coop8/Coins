//
//  MockGeckoService.swift
//  Coins
//
//  Created by Cooper Rockwell on 7/31/24.
//

import Foundation

final class MockGeckoService: GeckoService {
    func fetchTopCoins(limit: Int, completion: @escaping (Result<[Coin], Gecko.APIError>) -> Void) {
        let mockCoins = [
            Coin.exampleCoin
        ]
        completion(.success(mockCoins))
    }
    
    func fetchHistoricalData(for coinID: String, from startTimestamp: Int, to endTimestamp: Int, completion: @escaping (Result<Coin.details.MarketData, Gecko.APIError>) -> Void) {
        let mockMarketData = Coin.details.MarketData(
            prices: [
                [
                    1722444122866,
                    66374.31887142335
                ],
                [
                    1722444332190,
                    66410.0519783483
                ],
                [
                    1722444683188,
                    66383.28901306441
                ],
                [
                    1722445004335,
                    66386.81660765238
                ],
                [
                    1722445338032,
                    66314.87144206463
                ],
                [
                    1722445533698,
                    66351.59573675413
                ],
                [
                    1722445934492,
                    66405.45107443343
                ],
                [
                    1722446202867,
                    66419.73706035313
                ],
                [
                    1722446532351,
                    66435.78941403909
                ],
                [
                    1722446724637,
                    66552.45874041058
                ],
                [
                    1722447093240,
                    66516.26361424914
                ],
                [
                    1722447336345,
                    66525.81054400218
                ]
            ],
            market_caps: [
                [
                    1722444122866,
                    1309780143870.9106
                ],
                [
                    1722444332190,
                    1310225609734.482
                ],
                [
                    1722444683188,
                    1308827742361.9255
                ],
                [
                    1722445004335,
                    1310589260626.5981
                ],
                [
                    1722445338032,
                    1309938572261.9368
                ],
                [
                    1722445533698,
                    1308342096140.2537
                ],
                [
                    1722445934492,
                    1311669286170.976
                ],
                [
                    1722446202867,
                    1309914685449.7356
                ],
                [
                    1722446532351,
                    1310959611492.3416
                ],
                [
                    1722446724637,
                    1310959611492.3416
                ],
                [
                    1722447093240,
                    1312384984921.4065
                ],
                [
                    1722447336345,
                    1312634457960.2437
                ]
            ], 
            total_volumes: [
                [
                    1722444122866,
                    22682640450.59731
                ],
                [
                    1722444332190,
                    24536752002.89711
                ],
                [
                    1722444683188,
                    25030276049.525475
                ],
                [
                    1722445004335,
                    23875776999.387444
                ],
                [
                    1722445338032,
                    26661409194.984955
                ],
                [
                    1722445533698,
                    26864147419.929283
                ],
                [
                    1722445934492,
                    24159286008.49712
                ],
                [
                    1722446202867,
                    24337049078.95235
                ],
                [
                    1722446532351,
                    24385439715.50335
                ],
                [
                    1722446724637,
                    27052318344.419014
                ],
                [
                    1722447093240,
                    24104710674.30852
                ],
                [
                    1722447336345,
                    24000034815.469975
                ]
            ])
        completion(.success(mockMarketData))
    }
    
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
}
