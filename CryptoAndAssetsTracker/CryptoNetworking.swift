//
//  AssetNetworking.swift
//  CryptoAndAssetsTracker
//
//  Created by Kevin Taniguchi on 2/27/18.
//  Copyright © 2018 Taniguchi. All rights reserved.
//

import Foundation

class CryptoNetworkingController {
    
    static let shared = CryptoNetworkingController()
    
    private init() {}
    
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
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let data = data {
                do {
                    let coinList = try JSONDecoder().decode(CoinList.self, from: data)
                    completion(Result(coinList))
                }
                catch {
                    completion(Result(error))
                }
            }
            else if let error = error {
                completion(Result(error))
            }
            else {
                completion(Result(NetworkingErrors.noData))
            }
        }.resume()
    }

    func getCoinPrices(fromCrypto coins: [String], toCurrencies currencies: [String] = ["USD"], completion: @escaping ((Result<CoinPriceMeta>) -> Void)) {
        var comps = URLComponents(string: Routes.baseHost)
        comps?.path = "/data/pricemultifull"
        let fromCryptoItem =  URLQueryItem(name: "fsyms", value: coins.joined(separator: ","))
        let toCurrency = URLQueryItem(name: "tsyms", value: currencies.joined(separator: ","))
        comps?.queryItems = [fromCryptoItem, toCurrency]
        
        guard let url = comps?.url else {
            completion(Result(NetworkingErrors.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let data = data {
                do {
                    let coinPriceMeta = try JSONDecoder().decode(CoinPriceMeta.self, from: data)
                    completion(Result(coinPriceMeta))
                }
                catch {
                    completion(Result(error))
                }
            }
            else if let error = error {
                completion(Result(error))
            }
            else {
                completion(Result(NetworkingErrors.noData))
            }
        }.resume()
    }
    
    // convenience
    func loadInitialValues(stashCoinlist: @escaping ((CoinList) -> Void) ,completion: @escaping (Result<[CoinViewModel]>) -> Void ) {
        getTopVolumeCoins { [weak self] (result) in
            guard let strongSelf = self else {
                completion(Result(NetworkingErrors.unknown))
                return
            }
            if let coinList = result.value {
                stashCoinlist(coinList)
                let fromCryptosList = coinList.data.map{$0.coinInfo.name}
                strongSelf.getCoinPrices(fromCrypto: fromCryptosList, completion: { (pricesResult) in
                    guard let prices = pricesResult.value?.display else {
                        completion(Result(NetworkingErrors.noData))
                        return
                    }
                    completion(Result(strongSelf.generateViewModels(prices: prices, coinList: coinList)))
                })
            }
            else if let error = result.error {
                completion(Result(error))
            }
            else {
                completion(Result(NetworkingErrors.noData))
            }
        }
    }
    
    func generateViewModels(prices: [String: Coin], coinList: CoinList) -> [CoinViewModel] {
        var coinViewModels = [CoinViewModel]()
        for (key, value) in prices {
            if let coinInfo = coinList.data.first(where: {$0.coinInfo.name == key})?.coinInfo {
                let coinViewModel = CoinViewModel(info: coinInfo, coin: value)
                coinViewModels.append(coinViewModel)
            }
        }
        
        return coinViewModels
    }
}

struct Routes {
    static let baseHost = "https://min-api.cryptocompare.com"
    static let imageHost = "https://www.cryptocompare.com"
}
