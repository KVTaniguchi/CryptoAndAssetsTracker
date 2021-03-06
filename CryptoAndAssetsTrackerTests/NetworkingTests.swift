//
//  NetworkingTests.swift
//  CryptoAndAssetsTrackerTests
//
//  Created by Kevin Taniguchi on 2/27/18.
//  Copyright © 2018 Taniguchi. All rights reserved.
//

import XCTest
@testable import CryptoAndAssetsTracker

class NetworkingTests: XCTestCase {
    func testGetCoinListSuccess() {
        let promise = expectation(description: "success")
        
        CryptoNetworkingController.shared.getTopVolumeCoins { (result) in
            XCTAssertNotNil(result.value)
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetCoinListFailure() {
        let promise = expectation(description: "success")
        
        var comps = URLComponents(string: Routes.baseHost)
        comps?.path = "/data/top/totalvol"
        let limitItem = URLQueryItem(name: "FAILURE", value: "30")
        let pageItem = URLQueryItem(name: "FAILURE", value: "0")
        let toSymItem = URLQueryItem(name: "FAILURE", value: "USD")
        let extraParamItem = URLQueryItem(name: "FAILURE", value: "CryptoAndAssetsTracker")
        comps?.queryItems = [limitItem, pageItem, toSymItem, extraParamItem]
        
        guard let url = comps?.url else {
            XCTFail()
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let coinList = try JSONDecoder().decode(CoinList.self, from: data)
                    XCTAssertTrue(coinList.data.count == 0)
                    XCTAssertNil(coinList.data.first?.coinInfo)
                    promise.fulfill()
                }
                catch {
                    assertionFailure(error.localizedDescription)
                }
            }
        }.resume()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetCoinPriceMetaSuccess() {
        let promise = expectation(description: "success")
        CryptoNetworkingController.shared.getCoinPrices(fromCrypto: ["BTC"]) { (result) in
            XCTAssertNotNil(result.value)
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetCoinPriceMetaFailure() {
        let promise = expectation(description: "failure")
        var comps = URLComponents(string: Routes.baseHost)
        comps?.path = "/data/pricemultifull"
        let fromCryptoItem =  URLQueryItem(name: "FAILURE", value: "qwerqwerqwerqwerqwerqwer")
        let toCurrency = URLQueryItem(name: "FAILURE", value: "asdfasdfasdfasdf")
        comps?.queryItems = [fromCryptoItem, toCurrency]
        
        guard let url = comps?.url else {
            XCTFail()
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let data = data {
                do {
                    let coinPriceMeta = try JSONDecoder().decode(CoinPriceMeta.self, from: data)
                    XCTAssertTrue(coinPriceMeta.display.isEmpty)
                    promise.fulfill()
                }
                catch {
                    print(error)
                }
            }
        }.resume()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testViewModelGen() {
        let promise = expectation(description: "success")
        CryptoNetworkingController.shared.loadInitialValues(stashCoinlist: { (list) in
            
        }) { (result) in
            XCTAssertNotNil(result.value)
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

