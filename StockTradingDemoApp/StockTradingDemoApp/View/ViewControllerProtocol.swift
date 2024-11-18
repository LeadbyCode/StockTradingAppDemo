//
//  ViewControllerProtocol.swift
//  StockTradingAppDemo
//
//

import Foundation
protocol ViewControllerProtocol {
    var reloadTableView: (() -> Void)? { get set }
    func fetchStock()
    func numberOfUserStocks() -> Int
    func UserStocks(at index: Int) -> UserHolding?
    func getInvestmentResult() -> InvestmentResult?
}
