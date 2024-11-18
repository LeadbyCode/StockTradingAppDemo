//
//  Constant.swift
//  StockTradingAppDemo
//
//  Created by z004fx0n on 12/11/24.
//

import Foundation

// MARK: Constants to be used throught the project
enum Constants {
    enum HeightConstant {
        static let expendedBottomViewHeight: CGFloat = 230
        static let shrinkedBottomViewHeight: CGFloat = 80
        
        static let expendedBottomtableViewHeight: CGFloat = 150
    }
    enum XibName {
        static let userHoldingTableViewCell = "UserHoldingTableViewCell"
        static let expendedFooterTableViewCell = "ExpendedFooterTableViewCell"
        static let bottomInvestmentView = "BottomInvestmentView"
    }
    
    enum ImageName {
        static let upTriangleArrow = "arrowtriangle.up.fill"
        static let downTriangleArrow = "arrowtriangle.down.fill"
    }
    
    enum FontConstant {
        static let commonFontHeight: CGFloat = 14
        static let small: CGFloat = 8
        static let normal: CGFloat = 13
    }
    
    enum CustomStringFormats {
        static let rupeeSign = "\u{20B9}"
        static let formattedValueString = "%.2f"
    }
}
