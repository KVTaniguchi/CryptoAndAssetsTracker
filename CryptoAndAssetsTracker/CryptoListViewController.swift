//
//  AssetsListViewController.swift
//  CryptoAndAssetsTracker
//
//  Created by Kevin Taniguchi on 2/27/18.
//  Copyright © 2018 Taniguchi. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class CryptoListViewController: UITableViewController {
    private var dataSource = [CoinViewModel]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    private var currentiOSCurrency = "USD" // start with USD by default
    
    private let allCurrencies = Locale.isoCurrencyCodes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Top Crypto Currencies"
        
        tableView.register(ListCryptoCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedRowHeight = 44
        
        let pickerButton = UIButton(type: .custom)
        pickerButton.setTitle("Choose Currency", for: .normal)
        pickerButton.setTitleColor(view.tintColor, for: .normal)
        pickerButton.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
        pickerButton.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50.0)
        tableView.tableHeaderView = pickerButton
        
        CryptoNetworkingController.shared.loadInitialValues { [weak self] (result) in
            guard let viewModels = result.value else {
                return
            }
            
            self?.dataSource = viewModels
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ListCryptoCell, dataSource.count > 0 else {
            return UITableViewCell()
        }
        
        let viewModel = dataSource[indexPath.row]
        
        cell.configure(viewModel: viewModel, isoCurrency: currentiOSCurrency)
 
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCoin = dataSource[indexPath.row]
        let vc = CryptoDetailViewController(viewModel: selectedCoin)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showPicker() {
        
    }
}

class ListCryptoCell: UITableViewCell {
    let coinImageView = UIImageView()
    let fullNameLabel = UILabel()
    let abbrLabel = UILabel()
    let isoCurrencyLabel = UILabel()
    let isoCurrentValueLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        coinImageView.contentMode = .scaleAspectFit
        
        let nameSV = UIStackView(arrangedSubviews: [fullNameLabel, isoCurrencyLabel])
        nameSV.axis = .vertical
        nameSV.spacing = 18
        
        let isoSV = UIStackView(arrangedSubviews: [abbrLabel, isoCurrentValueLabel])
        isoSV.axis = .vertical
        isoSV.spacing = 18
        
        let fullSV = UIStackView(arrangedSubviews: [coinImageView, nameSV, isoSV, UIView()])
        fullSV.spacing = 30
        
        coinImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        coinImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        fullSV.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(fullSV)
        
        fullSV.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18).isActive = true
        fullSV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18).isActive = true
        fullSV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18).isActive = true
        fullSV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18).isActive = true
    }
    
    func configure(viewModel: CoinViewModel, isoCurrency: String) {
        if let url = viewModel.imageURL {
            coinImageView.kf.setImage(with: url)
        }
        
        fullNameLabel.text = viewModel.info.fullName
        abbrLabel.text = viewModel.info.name
        isoCurrencyLabel.text = "Value in \(isoCurrency): "
        isoCurrentValueLabel.text = viewModel.coin.details[isoCurrency]?.price
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
