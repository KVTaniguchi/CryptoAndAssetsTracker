//
//  ResultType.swift
//  CryptoAndAssetsTracker
//
//  Created by Kevin Taniguchi on 2/27/18.
//  Copyright © 2018 Taniguchi. All rights reserved.
//

import Foundation

protocol ResultType {
    associatedtype Value
    
    init(_ value: Value?)
    init(_ error: Error)
    
    var value: Value? { get }
    var error: Error? { get }
}

enum Result<T>: ResultType {
    typealias Value = T
    
    case success(Value?)
    case failure(Error)
    
    var value: Value? {
        switch self {
        case .success(let v):
            return v
        default:
            return nil
        }
    }
    
    var error: Error? {
        switch self {
        case .failure(let e):
            return e
        default:
            return nil
        }
    }
    
    init(_ value: Value?) {
        if let v = value as? Error {
            self = .failure(v)
        }
        else if let v = value {
            self = .success(v)
        }
        else {
            self = .success(nil)
        }
    }
    
    init(_ error: Error) {
        self = .failure(error)
    }
}
