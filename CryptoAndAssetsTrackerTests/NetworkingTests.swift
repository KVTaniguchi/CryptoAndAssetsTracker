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
        
        var comps = URLComponents(string: Routes.baseHost)
        comps?.path = "/data/top/totalvol"
        let limitItem = URLQueryItem(name: "limit", value: "30")
        let pageItem = URLQueryItem(name: "page", value: "0")
        let toSymItem = URLQueryItem(name: "tsym", value: "USD")
        let extraParamItem = URLQueryItem(name: "extraParams", value: "CryptoAndAssetsTracker")
        comps?.queryItems = [limitItem, pageItem, toSymItem, extraParamItem]
        
        guard let url = comps?.url else {
            XCTFail()
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let coinList = try JSONDecoder().decode(CoinList.self, from: data)
                    XCTAssertTrue(coinList.data.count > 20)
                    XCTAssertNotNil(coinList.data.first?.coinInfo)
                    promise.fulfill()
                }
                catch {
                    assertionFailure(error.localizedDescription)
                }
            }
        }.resume()
        
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
}

