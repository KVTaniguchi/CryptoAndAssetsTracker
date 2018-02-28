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
        let expectation = self.expectation()

        CryptoNetworkingController.shared.getTopVolumeCoins { (result) in
            if case .failure(let error) = result { XCTFail("should be success: \(error)") }
            expectation.fulfill()
        }

        waitForExpectations(timeout: XCTestCase.defaultTimeout)
    }
}

