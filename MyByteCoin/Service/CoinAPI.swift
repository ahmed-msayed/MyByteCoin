//
//  CoinAPI.swift
//  MyByteCoin
//
//  Created by Ahmed Sayed on 02/10/2021.
//

import Foundation

class CoinAPI {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "FDA12203-4B4E-493D-90BF-3101B56EA18E"
    typealias CoinResponseCompletion = (CoinRate?) -> Void
    
    func getCoinPrice(currency: String, completion: @escaping CoinResponseCompletion) {
        guard let url = URL(string: "\(baseURL)/\(currency)?apikey=\(apiKey)") else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                debugPrint(error.debugDescription)
                return
            }
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                if let parsedRate = self.parseJSON(data) {
                    completion(parsedRate)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(_ rateData: Data) -> CoinRate? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinRate.self, from: rateData)
            
            let rate = decodedData.rate
            let rate2 = CoinRate(rate: rate)
            
            return rate2
        } catch {
            print(error)
            return nil
        }
    }
}
