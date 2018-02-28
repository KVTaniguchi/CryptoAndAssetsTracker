//
//  AssetNetworking.swift
//  CryptoAndAssetsTracker
//
//  Created by Kevin Taniguchi on 2/27/18.
//  Copyright © 2018 Taniguchi. All rights reserved.
//

import Foundation

class CryptoNetworkingController {
    
    private let session = URLSession(configuration: .default)
    
    static let shared = CryptoNetworkingController()
    
    func getTopVolumeCoins(toCurrency: String = "USD", completion: @escaping ((Result<CoinList>) -> Void)) {
        var comps = URLComponents(string: Routes.baseHost)
        comps?.path = "/data/top/totalvol"
        let limitItem = URLQueryItem(name: "limit", value: "30")
        let pageItem = URLQueryItem(name: "page", value: "0")
        let toSymItem = URLQueryItem(name: "tsym", value: toCurrency)
        let extraParamItem = URLQueryItem(name: "extraParams", value: "CryptoAndAssetsTracker")
        comps?.queryItems = [limitItem, pageItem, toSymItem, extraParamItem]
        
        guard let url = comps?.url else {
            completion(Result(NetworkingErrors.badURL))
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let coinList = try JSONDecoder().decode(CoinList.self, from: data)
                    completion(Result(coinList))
                }
                catch {
                    completion(Result(error))
                }
            }
            if let error = error {
                completion(Result(error))
            }
            else {
                completion(Result(NetworkingErrors.noData))
            }
        }
        
        task.resume()
    }

}

// experimenting with ways to structure URLs
struct Routes {
    static let baseHost = "https://min-api.cryptocompare.com"
}


//struct Data {
//    static let path = "/data"
//    
//    struct Top {
//        static let path = "/top"
//        
//        struct TotalVolume {
//            static let path = "/totalvol"
//        }
//    }
//    
//    struct SinglePrice {
//        static let path = "/price"
//    }
//    
//    struct MultiFullDataPath {
//        static let pricemultFullDataPath = "/pricemultifull"
//    }
//    
//    struct HistodayPath {
//        static let histodayPath = "/histoday"
//    }
//}

