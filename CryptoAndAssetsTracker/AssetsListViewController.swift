//
//  AssetsListViewController.swift
//  CryptoAndAssetsTracker
//
//  Created by Kevin Taniguchi on 2/27/18.
//  Copyright © 2018 Taniguchi. All rights reserved.
//

import Foundation
import UIKit

class CryptoListViewController: UIViewController {
    
    // first let's test that this api works
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Crypto List"
        
        let session = URLSession(configuration: .default)
        
//        https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC&tsyms=USD
        
        if let url = URL(string: "https://min-api.cryptocompare.com/data/top/totalvol?limit=30&page=0&tsym=USD&extraParams=CryptoAndAssetsTracker") {
            let dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if let data = data {
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print("JSON: \(String(describing: json))")
                    }
                    catch {}
                }
                
                if let error = error {
                    print("err: \(error)")
                }
            })
            
            dataTask.resume()
        }
    }
}
