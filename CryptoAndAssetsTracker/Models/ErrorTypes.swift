//
//  ErrorTypes.swift
//  CryptoAndAssetsTracker
//
//  Created by Kevin Taniguchi on 2/27/18.
//  Copyright © 2018 Taniguchi. All rights reserved.
//

import Foundation

enum NetworkingErrors: Error {
    case badURL
    case noData // we are going to assume we will *never* get an empty response
    case unknown
}

enum ModelError: Error {
    case coinData
    case coinPrice
}
