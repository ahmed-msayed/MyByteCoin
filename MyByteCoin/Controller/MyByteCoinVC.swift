//
//  MyByteCoinVC.swift
//  MyByteCoin
//
//  Created by Ahmed Sayed on 02/10/2021.
//

import UIKit

class MyByteCoinVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let coinApi = CoinAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        let defaultIndexValue = "USD"
        setDefaultValue(item: defaultIndexValue, inComponent: 0)
        fetchPriceFromAPI(currency: defaultIndexValue)
        currencyLbl.text = defaultIndexValue
        
        rateView.layer.cornerRadius = 25
    }
    
    func setDefaultValue(item: String, inComponent: Int){
        if let indexPosition = currencyArray.firstIndex(of: item){
            pickerView.selectRow(indexPosition, inComponent: inComponent, animated: true)
        }
    }
    
    func fetchPriceFromAPI(currency: String) {
        coinApi.getCoinPrice(currency: currency) { (parsedData) in
            if let parsedData = parsedData {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                let decimalRate = formatter.string(from: NSNumber(value: parsedData.rate))
                self.rateLbl.text = decimalRate
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {   //number of columns
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = currencyArray[row]
        currencyLbl.text = selectedCurrency
        fetchPriceFromAPI(currency: selectedCurrency)
    }
}

