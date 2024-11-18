//
//  userHoldingTableViewCell.swift
//  StockTradingAppDemo
//
//  Created by z004fx0n on 12/11/24.
//

import UIKit

class UserHoldingTableViewCell: UITableViewCell {
    
    let symbolLabel = UILabel()
    let ltpLabel = UILabel()
    let quantityStackView = CustomView(smallLabelText: "Small Text", largeLabelText: "Large Text")
    let profitAndLossLabelView = CustomView(smallLabelText: "Small Text", largeLabelText: "Large Text")
    
    var userHoldingdata: UserHolding? {
        didSet {
            bindCellData(for: userHoldingdata)
        }
    }
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(symbolLabel)
        contentView.addSubview(ltpLabel)
        contentView.addSubview(quantityStackView)
        contentView.addSubview(profitAndLossLabelView)
        
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        ltpLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityStackView.translatesAutoresizingMaskIntoConstraints = false
        //        profitAndLossLabel.translatesAutoresizingMaskIntoConstraints = false
        profitAndLossLabelView.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    private func bindCellData(for dataForCurrentCell: UserHolding?) {
        guard let dataForCurrentCell else { return }
        symbolLabel.text = dataForCurrentCell.symbol.uppercased()
        ltpLabel.attributedText = getAttributedText(with: "LTP", and: dataForCurrentCell.ltp)
        quantityStackView.updateNetQty("\(dataForCurrentCell.quantity)", "NET QTY: ")
        profitAndLossLabelView.updateProfitLossLabel(dataForCurrentCell.profitAndLoss, "P/L:")
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        // Top left label constraints
        NSLayoutConstraint.activate([
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            symbolLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
        
        // Top right label constraints
        NSLayoutConstraint.activate([
            ltpLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            ltpLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
        
        // Bottom left label constraints
        NSLayoutConstraint.activate([
            quantityStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            quantityStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        // Bottom right label constraints
        NSLayoutConstraint.activate([
            profitAndLossLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            profitAndLossLabelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            profitAndLossLabelView.leadingAnchor.constraint(equalTo: ltpLabel.leadingAnchor)

        ])
        symbolLabel.font = UIFont.systemFont(ofSize: Constants.FontConstant.commonFontHeight, weight: .bold)
    }
    
    private func getAttributedText(with prefix: String, and amount: Double) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        
        // Create the prefix with a small font size of 8 and thin font weight
        let prefixAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 8, weight: .thin)
        ]
        let prefixAttributedString = NSAttributedString(string: "\(prefix): ", attributes: prefixAttributes)
        
        // Append the prefix part
        attributedString.append(prefixAttributedString)
        
        // Format the amount to a rounded string
        let roundedAmountString = String(format: Constants.CustomStringFormats.formattedValueString, amount)
        
        // Create the amount part with a font size of 13 and thin font weight
        let amountAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13, weight: .regular)
        ]
        let boldedString = NSAttributedString(string: "\(Constants.CustomStringFormats.rupeeSign) \(roundedAmountString)", attributes: amountAttributes)
        
        // Append the amount part
        attributedString.append(boldedString)
        
        return attributedString
    }
    
}


class CustomView: UIView {
    
    // Define the labels
    private let smallLabel = UILabel()
    private let largeLabel = UILabel()
    
    // Define the stack view
    private let labelStackView = UIStackView()
    
    // Initializer
    init(smallLabelText: String, largeLabelText: String) {
        super.init(frame: .zero)
        
        smallLabel.text = smallLabelText
        largeLabel.text = largeLabelText
        
          
        configureStackView()
        configureLabel()
        addSubview(labelStackView)
        
        // Enable Auto Layout
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabel() {
        smallLabel.font = UIFont.systemFont(ofSize: 9, weight: .thin)
        largeLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)

    }
    
    private func configureStackView() {
        labelStackView.axis = .horizontal // Set axis to horizontal
        labelStackView.alignment = .center // Center align the labels vertically
        labelStackView.spacing = 2
        // Add labels to the stack view
        labelStackView.addArrangedSubview(smallLabel)
        labelStackView.addArrangedSubview(largeLabel)
    }
    
    // Set up Auto Layout constraints for the stack view
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelStackView.topAnchor.constraint(equalTo: topAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func updateProfitLossLabel(_ largetext: Double,_ smalltext: String) {
        smallLabel.text = smalltext
        largeLabel.attributedText = getAttributedText(and: largetext)
    }
    

    private func getAttributedText(and amount: Double) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        
        let roundedAmountString = String(format: Constants.CustomStringFormats.formattedValueString, amount)
        
        let color: UIColor = amount < 0 ? .red : .green
        
        let amountAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13, weight: .regular),
            .foregroundColor: color
        ]
        
        let boldedString = NSAttributedString(string: "\(Constants.CustomStringFormats.rupeeSign) \(roundedAmountString)", attributes: amountAttributes)
        
        // Append the amount part
        attributedString.append(boldedString)
        
        return attributedString
    }
    func updateNetQty(_ largetext: String,_ smalltext: String) {
        smallLabel.text = smalltext
        largeLabel.text = largetext
    }
}
