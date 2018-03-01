//
//  TestHelper.swift
//  CryptoAndAssetsTrackerTests
//
//  Created by Kevin Taniguchi on 2/27/18.
//  Copyright © 2018 Taniguchi. All rights reserved.
//

import XCTest
@testable import CryptoAndAssetsTracker

private class TestHelper {}

func dataFor(_ path: String, ext: String = "json") -> Data? {
    let actualBundle = Bundle(for: TestHelper.self)
    
    if let path = actualBundle.path(forResource: path, ofType: ext),
        let d = try? Data(contentsOf: URL(fileURLWithPath: path)) {
        return d
    }
    
    return nil
}

extension XCTest {
    static var defaultTimeout: TimeInterval {
        return 2.0
    }
}

extension XCTestCase {
    open func expectation() -> XCTestExpectation {
        return expectation(description: "\(#function), \(#file), \(#line)")
    }
}
