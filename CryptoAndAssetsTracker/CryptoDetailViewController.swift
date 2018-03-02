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
    private let isoCurrency: String
    
    init(viewModel: CoinViewModel, isoCurrency: String) {
        self.viewModel = viewModel
        self.isoCurrency = isoCurrency
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.info.fullName
        view.backgroundColor = .white
        
        let coinImageView = UIImageView()
        let fullNameLabel = UILabel()
        let abbrLabel = UILabel()
        let isoCurrencyLabel = UILabel()
        let isoCurrentValueLabel = UILabel()
        
        let mainSV = UIStackView(arrangedSubviews: [coinImageView])
        mainSV.axis = .vertical
        mainSV.spacing = 20
        mainSV.alignment = .center
        
        let leftSV = UIStackView(arrangedSubviews: [fullNameLabel, abbrLabel])
        leftSV.axis = .vertical
        
        let rightSV = UIStackView(arrangedSubviews: [isoCurrencyLabel, isoCurrentValueLabel])
        rightSV.axis = .vertical
        
        let lMargin = UIView()
        let rMargin = UIView()
        let columnsSV = UIStackView(arrangedSubviews: [lMargin, leftSV, rightSV, rMargin])
        columnsSV.spacing = 30
        lMargin.widthAnchor.constraint(equalToConstant: 40).isActive = true
        rMargin.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        coinImageView.kf.setImage(with: viewModel.imageURL)
        fullNameLabel.text = viewModel.info.fullName
        abbrLabel.text = viewModel.info.name
        isoCurrencyLabel.text = "Value in \(isoCurrency): "
        isoCurrentValueLabel.text = viewModel.coin.details[isoCurrency]?.price
        
        mainSV.addArrangedSubview(columnsSV)
        
        mainSV.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainSV)
        mainSV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        mainSV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mainSV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
