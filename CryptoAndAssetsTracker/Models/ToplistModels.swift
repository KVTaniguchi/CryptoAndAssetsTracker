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

struct Detail: Decodable {
    let fromSymbol: String
    let toSymbol: String
    let price: String
    let highDay: String
    let lowDay: String
    let changeDay: String
    let changePercentDay: String

    enum CodingKeys: String, CodingKey {
        case fromSymbol = "FROMSYMBOL"
        case toSymbol = "TOSYMBOL"
        case price = "PRICE"
        case highDay = "HIGHDAY"
        case lowDay = "LOWDAY"
        case changeDay = "CHANGEDAY"
        case changePercentDay = "CHANGEPCTDAY"
    }
}

struct Coin: Decodable {
    
    let details: [String: Detail]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GenericCodingKeys.self)
        
        var dict = [String: Detail]()
        for key in container.allKeys {
            let data = try container.decode(Detail.self, forKey: key)
            dict[key.stringValue] = data
        }
        
        self.details = dict
    }
}

struct CoinPriceMeta: Decodable {
    let display: [String: Coin]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GenericCodingKeys.self)
        
        var dict = [String: Coin]()
        // nested for loop is faster than the functional methods .map / .reduce
        for key in container.allKeys {
            if let value = try? container.nestedContainer(keyedBy: GenericCodingKeys.self, forKey: key)  {
                for key in value.allKeys {
                    let coin = try? value.decode(Coin.self, forKey: key)
                    dict[key.stringValue] = coin
                }
            }
        }
        
        self.display = dict
    }
}

struct GenericCodingKeys: CodingKey, ExpressibleByStringLiteral {
    // MARK: CodingKey
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) { self.stringValue = stringValue }
    init?(intValue: Int) { return nil }
    
    // MARK: ExpressibleByStringLiteral
    typealias StringLiteralType = String
    init(stringLiteral: StringLiteralType) { self.stringValue = stringLiteral }
}

