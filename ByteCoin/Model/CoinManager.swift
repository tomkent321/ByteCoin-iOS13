//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateRate(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(error: Error)
}




struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = 
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
       print("currency is: \(currency)")
       let urlString = baseURL + "/\(currency)" + "?apikey=" + apiKey
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {

        // 1. Create a URL
        if let url = URL(string: urlString) {

            // 2. Create a URLSession
            let session = URLSession(configuration: .default)

            // 3. Give the session a task...an annonymous function with a trailing closure see lesson 151
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }

                // see lesson 153 "self" must be added in an enclosure
                if let safeData = data {
                    if let coin = self.parseJSON(safeData) {
                        self.delegate?.didUpdateRate(self, coin: coin)

                    }
                }
            }

            // 4. Start the task
            task.resume()

        }
    
    
}
    
    func parseJSON(_ coinData: Data) -> CoinModel? {
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            print(decodedData)
            if decodedData.time != "" {
            let time = decodedData.time
                let asset_id_base = decodedData.asset_id_base
            let asset_id_quote = decodedData.asset_id_quote
            let rate = decodedData.rate
           
                let coin = CoinModel(time: time, asset_id_base: asset_id_base, asset_id_quote: asset_id_quote, rate: rate)
                return coin
            } else {
                
                let time = "NA"
                    let asset_id_base = "NA"
                let asset_id_quote = "NA"
                let rate = 0.0
                let coin = CoinModel(time: time, asset_id_base: asset_id_base, asset_id_quote: asset_id_quote, rate: rate)

                    return coin
            }
            
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
    
    
    
}




