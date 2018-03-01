//
//  AssetDetailViewController.swift
//  CryptoAndAssetsTracker
//
//  Created by Kevin Taniguchi on 2/27/18.
//  Copyright © 2018 Taniguchi. All rights reserved.
//

import Foundation
import UIKit

class CryptoDetailViewController: UIViewController {
    private let viewModel: CoinViewModel
    
    init(viewModel: CoinViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.info.fullName
        
        view.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
