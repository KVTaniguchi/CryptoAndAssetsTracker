//
//  ToplistModels.swift
//  CryptoAndAssetsTracker
//
//  Created by Kevin Taniguchi on 2/27/18.
//  Copyright © 2018 Taniguchi. All rights reserved.
//

import Foundation

struct CoinViewModel {
    let info: CoinInfo
    let coin: Coin
}

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

struct RawDetail: Decodable {
    let total24HourVolume: Double
    
    enum CodingKeys: String, CodingKey {
        case total24HourVolume = "VOLUME24HOURTO"
    }
}

struct Coin: Decodable {
    
    let details: [String: Detail]
    let rawDetails: [String: RawDetail]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GenericCodingKeys.self)
        
        var detailsDict = [String: Detail]()
        var rawDetailsDict = [String: RawDetail]()
        for key in container.allKeys {
            if let data = try? container.decode(Detail.self, forKey: key) {
                detailsDict[key.stringValue] = data
            }
            else if let rawData = try? container.decode(RawDetail.self, forKey: key) {
                rawDetailsDict[key.stringValue] = rawData
            }
        }
        
        self.details = detailsDict
        self.rawDetails = rawDetailsDict
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

// I need this due to the keys in the pricing responses not being known until the response is received
struct GenericCodingKeys: CodingKey, ExpressibleByStringLiteral {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    // afaik none of these crypto keys are ints
    init?(intValue: Int) { return nil }
    typealias StringLiteralType = String
    init(stringLiteral: StringLiteralType) { self.stringValue = stringLiteral }
}

