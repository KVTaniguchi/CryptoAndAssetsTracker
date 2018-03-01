//
//  CryptoAndAssetsTrackerTests.swift
//  CryptoAndAssetsTrackerTests
//
//  Created by Kevin Taniguchi on 2/27/18.
//  Copyright © 2018 Taniguchi. All rights reserved.
//

import XCTest
@testable import CryptoAndAssetsTracker

class CryptoAndAssetsTrackerTests: XCTestCase {
    
    func testCoinListInits() {
        guard let json = dataFor("CorrectCoinList") else {
            XCTFail("Failed to get data from json file")
            return
        }
        
        do {
            let coinList = try JSONDecoder().decode(CoinList.self, from: json)
            
            guard let firstCoinInfo = coinList.data.first?.coinInfo else {
                XCTFail("No coins")
                return
            }
            
            XCTAssertEqual("1182", firstCoinInfo.id)
            XCTAssertEqual("BTC", firstCoinInfo.name)
            XCTAssertEqual("Bitcoin", firstCoinInfo.fullName)
            XCTAssertEqual("/media/19633/btc.png", firstCoinInfo.imageURL)
            XCTAssertEqual("/coins/btc/overview", firstCoinInfo.url)
            XCTAssertEqual("SHA256", firstCoinInfo.algorithm)
            XCTAssertEqual("PoW", firstCoinInfo.proofType)
            XCTAssertEqual("Webpagecoinp", firstCoinInfo.documentType)
        }
        catch {
            XCTFail("Failed to decode \(error.localizedDescription)")
        }
    }
    
    func testBadCoinListData() {
        guard let json = dataFor("MissingValuesCoinList") else {
            XCTFail("Failed to get data from json file")
            return
        }
        
        do {
            let coinList = try JSONDecoder().decode(CoinList.self, from: json)
            XCTAssertTrue(coinList.data.isEmpty)
        }
        catch {
            XCTAssertNotNil(error, "\(error.localizedDescription)")
        }
    }
    
    func testCoinPrices() {
        guard let data = dataFor("CorrectCoinPriceList") else {
            XCTFail()
            return
        }
        
        do {
            let coinPrices = try JSONDecoder().decode(CoinPriceMeta.self, from: data)
            XCTAssert(!coinPrices.display.isEmpty)
            let dollarValueOfBitCoin = coinPrices.display["BTC"]?.details["USD"]?.price
            XCTAssertEqual("$ 10,401.3", dollarValueOfBitCoin)
        }
        catch {
            XCTFail("Failed to decode \(error.localizedDescription)")
        }
    }
    
    func testBadCoinPriceData() {
        guard let data = dataFor("MissingValuesPriceList") else {
            XCTFail()
            return
        }
        
        do {
            let coinPrices = try JSONDecoder().decode(CoinPriceMeta.self, from: data)
            XCTAssert(!coinPrices.display.isEmpty)
            let dollarValueOfBitCoin = coinPrices.display["BTC"]?.details["USD"]?.price
            XCTAssertNil(dollarValueOfBitCoin)
        }
        catch {
            XCTFail("Failed to decode \(error.localizedDescription)")
        }
    }
}
