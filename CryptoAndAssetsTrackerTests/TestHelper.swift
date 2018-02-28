//
//  TestHelper.swift
//  CryptoAndAssetsTrackerTests
//
//  Created by Kevin Taniguchi on 2/27/18.
//  Copyright © 2018 Taniguchi. All rights reserved.
//

import Foundation

private class TestHelper {}

public func jsonFor(_ path: String, ext: String = "json") -> Data? {
    let actualBundle = Bundle(for: TestHelper.self)
    
    if let path = actualBundle.path(forResource: path, ofType: ext),
        let d = try? Data(contentsOf: URL(fileURLWithPath: path)) {
        return d
    }
    
    return nil
}
