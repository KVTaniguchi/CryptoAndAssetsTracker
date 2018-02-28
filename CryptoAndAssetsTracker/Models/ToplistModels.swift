//
//  ToplistModels.swift
//  CryptoAndAssetsTracker
//
//  Created by Kevin Taniguchi on 2/27/18.
//  Copyright © 2018 Taniguchi. All rights reserved.
//

import Foundation

struct CoinList: Decodable {
    let data: [Coin]
    
    enum CodingKeys: String, CodingKey {
        case data = "Data"
    }
}

struct Coin: Decodable {
    let coinInfo: CoinInfo
    
    enum CodingKeys: String, CodingKey {
        case coinInfo = "CoinInfo"
    }
}

struct CoinInfo: Decodable {
    let id: String
    let name: String
    let fullName: String
    let imageURL: String
    let url: String
    let algorithm: String
    let proofType: String
    let documentType: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case fullName = "FullName"
        case imageURL = "ImageUrl"
        case url = "Url"
        case algorithm = "Algorithm"
        case proofType = "ProofType"
        case documentType = "DocumentType"
    }
}


