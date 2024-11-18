//
//  ViewControllerViewModel.swift
//  StockTradingAppDemo
//
//  Created by z004fx0n on 13/11/24.
//

import Foundation

class ViewControllerViewModel :ViewControllerProtocol{
    var reloadTableView: (() -> Void)?
    var userHoldings: [UserHolding]?

    func numberOfUserStocks() -> Int {
        return userHoldings?.count ?? 0
    }

    func UserStocks(at index: Int) -> UserHolding? {
        return userHoldings?[index]
    }
    func fetchStock() {
        fetchJSON(from: "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/", decodeType: StockData.self) { result in
            switch result {
            case .success(let item):
                DispatchQueue.main.async {
                    self.userHoldings = item.data?.userHolding ?? []
 
                    self.reloadTableView?()
                }
            case .failure(let error):
                print("Error:", error)
                self.reloadTableView?()
            }
        }
    }
    func fetchJSON<T: Decodable>(from urlString: String, decodeType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code:", httpResponse.statusCode)
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(decodeType, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    func getInvestmentResult() -> InvestmentResult? {
        guard let userHoldings else { return nil }
        var totalCurrentValue: Double = 0
        var totalInvestment: Double = 0
        var todaysProfitAndLoss: Double = 0
        
        for userHolding in userHoldings {
            totalCurrentValue += userHolding.currentValue
            totalInvestment += userHolding.investmentValue
            todaysProfitAndLoss += (Double(userHolding.close) - userHolding.ltp ) * Double(userHolding.quantity)
        }
        let totalProfitAndLoss: Double = totalCurrentValue - totalInvestment
        
        let investmentValueFormat = Constants.CustomStringFormats.rupeeSign + Constants.CustomStringFormats.formattedValueString
        let totalCurrentValueStr = String(format: investmentValueFormat, totalCurrentValue)
        let totalInvestmentStr = String(format: investmentValueFormat, totalInvestment)
        let todaysProfitAndLossStr = String(format: investmentValueFormat, todaysProfitAndLoss)
        let totalProfitAndLossStr = String(format: investmentValueFormat, totalProfitAndLoss)
        
        return InvestmentResult(totalCurrentValue: totalCurrentValueStr, totalInvestment: totalInvestmentStr, totalProfitAndLoss: todaysProfitAndLossStr, todaysProfitAndLoss: totalProfitAndLossStr)
    }
}
