//
//  ViewController.swift
//  Bitcoin Ticker
//
//  Created by Matthew Tripodi on 11/17/18.
//  Copyright © 2018 Matthew Tripodi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var currencySelected = ""
    var finalURL = ""
    
    
    
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var weekBitcoinPriceLabel: UILabel!
    @IBOutlet weak var monthBitcoinPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        getBitcoinPrice(url: "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCUSD")
        currencySelected = "$"
        currencyPicker.selectRow(19, inComponent: 0, animated: true)
        
        roundedLabelCorners()
    }
    
    // PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        return NSAttributedString(string: String(currencyArray[row]), attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        currencySelected = currencySymbolArray[row]
        getBitcoinPrice(url: finalURL)
        
    }
    
    
    func roundedLabelCorners() {
        bitcoinPriceLabel.layer.borderWidth = 5 / UIScreen.main.nativeScale
        bitcoinPriceLabel.layer.backgroundColor = #colorLiteral(red: 0.963262856, green: 0.7103962302, blue: 0.2614393532, alpha: 1)
        bitcoinPriceLabel.layer.cornerRadius = 10
        
        weekBitcoinPriceLabel.layer.borderWidth = 5 / UIScreen.main.nativeScale
        weekBitcoinPriceLabel.layer.backgroundColor = #colorLiteral(red: 0.963262856, green: 0.7103962302, blue: 0.2614393532, alpha: 1)
        weekBitcoinPriceLabel.layer.cornerRadius = 10
        
        monthBitcoinPriceLabel.layer.borderWidth = 5 / UIScreen.main.nativeScale
        monthBitcoinPriceLabel.layer.backgroundColor = #colorLiteral(red: 0.963262856, green: 0.7103962302, blue: 0.2614393532, alpha: 1)
        monthBitcoinPriceLabel.layer.cornerRadius = 10
    }
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinPrice(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    print("Sucess! Got the Bitcoin data")
                    let bitcoinJSON : JSON = JSON(response.result.value!)
                    
                    self.updateBitcoinData(json: bitcoinJSON)
                    
                }
                else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
        }
    }
    
    
    //    //MARK: - JSON Parsing
    //    /***************************************************************/
    
    func updateBitcoinData(json : JSON) {
        
        if let priceResult = json["averages"]["day"].double {
            bitcoinPriceLabel.text = "\(currencySelected)\(priceResult)"
        }
        else {
            
            bitcoinPriceLabel.text = "Bitcoint Price Unavailable"
        }
        
        if let weekPriceResult = json["averages"]["week"].double {
            weekBitcoinPriceLabel.text = "\(currencySelected)\(weekPriceResult)"
        }
        else {
            weekBitcoinPriceLabel.text = "Bitcoin Price Unavailable"
        }
        
        if let monthPriceResult = json["averages"]["month"].double {
            monthBitcoinPriceLabel.text = "\(currencySelected)\(monthPriceResult)"
        }
        else {
            monthBitcoinPriceLabel.text = "Bitcoin Price Unavailable"
        }
        
        if let dateResult = json["display_timestamp"].string {
            
            let dateFormatter = DateFormatter()
            
            if let date = dateFormatter.date(from: dateResult) {
            
                dateLabel.text = "\(date)"
            }
            
           
        }
        else {
            dateLabel.text = "Date Unavailable"
        }
    }

}

extension DateFormatter {
    func dateFormat(fromString dateString: String) -> Date? {
        dateFormat = "EEEE, MMM d, yyyy"
        return self.date(from: dateString)
    }
}

