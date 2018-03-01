//
//  ToplistModels.swift
//  CryptoAndAssetsTracker
//
//  Created by Kevin Taniguchi on 2/27/18.
//  Copyright © 2018 Taniguchi. All rights reserved.
//

import Foundation

struct CoinList: Decodable {
    let data: [CoinData]
    
    enum CodingKeys: String, CodingKey {
        case data = "Data"
    }
}

struct CoinData: Decodable {
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


struct CoinPriceMeta {
    let display: [Coin]
    
    enum CodingKeys: String, CodingKey {
        case display = "DISPLAY"
    }
    
    struct Coin {
        let coinPrices: [CoinPrices]
        let name: String
        
        struct CodingKeys: CodingKey {
            var stringValue: String
            
            init?(stringValue: String) {
                self.stringValue = stringValue
            }
            
            static func makeKey(name: String) -> CodingKeys? {
                guard let key = CodingKeys(stringValue: name) else { return nil }
                return key
            }
            
            // there are not any Int value keys in these responses
            var intValue: Int?
            init?(intValue: Int) { return nil }
        }
        
        struct CoinPrices {
            let fromSymbol: String
            let toSymbol: String
            let price: String
            let openDay: String
            let highDay: String
            let lowDay: String
            let changeDay: String
            let changePercentDay: String
        }
    }
}




