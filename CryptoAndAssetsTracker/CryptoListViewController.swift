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

class CryptoListViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    private var dataSource = [CoinViewModel]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    private let picker = UIPickerView()
    
    private var currentiOSCurrency = "USD" {
        didSet {
            if let currentList = stashedCoinlist?.data.map({$0.coinInfo.name}) {
                CryptoNetworkingController.shared.getCoinPrices(fromCrypto: currentList, toCurrencies: [currentiOSCurrency]) {[weak self] (pricesResult) in
                    guard let prices = pricesResult.value?.display, let coinlist = self?.stashedCoinlist else {
                        return
                    }
                    
                    self?.dataSource = CryptoNetworkingController.shared.generateViewModels(prices: prices, coinList: coinlist)
                }
            }
        }
    }
    
    private let allCurrencies = ["USD", "EUR", "GBP", "CNY"]
    private let dummy = UITextField(frame: .zero)
    private var stashedCoinlist: CoinList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Top Crypto Currencies"
        
        tableView.register(ListCryptoCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedRowHeight = 44
        
        picker.dataSource = self
        picker.delegate = self
        picker.accessibilityIdentifier = "picker"
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        view.addSubview(dummy)
        
        dummy.inputView = picker
        dummy.inputAccessoryView = toolBar
        
        let pickerButton = UIButton(type: .custom)
        pickerButton.setTitle("Choose Currency", for: .normal)
        pickerButton.setTitleColor(view.tintColor, for: .normal)
        pickerButton.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
        pickerButton.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50.0)
        tableView.tableHeaderView = pickerButton
        
        CryptoNetworkingController.shared.loadInitialValues(stashCoinlist: { [weak self] coinList in
            self?.stashedCoinlist = coinList
        }) { [weak self] (result) in
            guard let viewModels = result.value else {
                return
            }

            self?.dataSource = viewModels
        }
    }
    
    @objc func donePicker() {
        if picker.selectedRow(inComponent: 0) > 0 {
            currentiOSCurrency = allCurrencies[picker.selectedRow(inComponent: 0)]
        }
        
        dummy.resignFirstResponder()
    }
    
    @objc func cancelPicker() {
        dummy.resignFirstResponder()
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
        let vc = CryptoDetailViewController(viewModel: selectedCoin, isoCurrency: currentiOSCurrency)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allCurrencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allCurrencies.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @objc func showPicker() {
        dummy.becomeFirstResponder()
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
        fullSV.alignment = .center
        fullSV.spacing = 30
        
        coinImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        coinImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 60).isActive = true
        
        fullSV.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(fullSV)
        
        fullSV.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 18).isActive = true
        fullSV.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 18).isActive = true
        fullSV.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -18).isActive = true
        fullSV.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -18).isActive = true
    }
    
    func configure(viewModel: CoinViewModel, isoCurrency: String) {
        coinImageView.kf.setImage(with: viewModel.imageURL)
        fullNameLabel.text = viewModel.info.fullName
        abbrLabel.text = viewModel.info.name
        isoCurrencyLabel.text = "Value in \(isoCurrency): "
        isoCurrentValueLabel.text = viewModel.coin.details[isoCurrency]?.price
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
