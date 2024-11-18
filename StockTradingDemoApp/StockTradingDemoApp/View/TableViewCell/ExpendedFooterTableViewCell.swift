//
//  ExpendedFooterView.swift
//  StockTradingAppDemo
//
//  Created by z004fx0n on 12/11/24.
//

import UIKit

class ExpendedFooterTableViewCell: UITableViewCell {

    // Define the two labels with specific names
    private let investementLabel = UILabel()
    private let amountLabel = UILabel()
    
    
    var investementLabelText: String? {
        didSet { investementLabel.text = investementLabelText }
    }
    var amountLabelText: String? {
        didSet { amountLabel.text = amountLabelText }
    }
    
    // Initializer for the custom table view cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        // Configure labels
        configureLabels()
        
        // Add labels to the content view (standard for table view cells)
        contentView.addSubview(investementLabel)
        contentView.addSubview(amountLabel)
        
        // Enable Auto Layout
        investementLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // Configure labels
        configureLabels()
        
        // Add labels to the content view
        contentView.addSubview(investementLabel)
        contentView.addSubview(amountLabel)
        
        // Enable Auto Layout
        investementLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints
        setupConstraints()
    }
    
    private func configureLabels() {
        investementLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        amountLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            investementLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            investementLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            amountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            amountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configureCell(investmentText: String, amountText: String) {
        investementLabel.text = investmentText
        amountLabel.text = amountText
    }
}
