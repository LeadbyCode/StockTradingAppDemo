import UIKit

class BottomFooterView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private let profitAndLossTextLabel = UILabel()
    private let profitAndLossValueLable = UILabel()
    private let expandCollapseButton = UIButton(type: .system)
    private var investmentResult: InvestmentResult?

    private let tableView = UITableView()
    
    private var isExpanded = false
    private var heightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        configureLabels()
        configureButton()
        
        addSubview(profitAndLossTextLabel)
        addSubview(expandCollapseButton)
        addSubview(profitAndLossValueLable)
        addSubview(tableView)  // Add table view
        
        setupConstraints()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExpendedFooterTableViewCell.self, forCellReuseIdentifier: "ExpendedFooterTableViewCell")
        tableView.isHidden = true // Initially hidden
    }
    func bindDataToExpendedView(for investmentResult: InvestmentResult){
        self.investmentResult = investmentResult
        
        self.profitAndLossTextLabel.text = "Profit & Loss:*"
        self.profitAndLossValueLable.text = investmentResult.totalProfitAndLoss
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabels() {
        profitAndLossTextLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        profitAndLossValueLable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    }
    
    private func configureButton() {
        expandCollapseButton.setTitle("^", for: .normal)
        expandCollapseButton.tintColor = .black
        expandCollapseButton.addTarget(self, action: #selector(toggleExpandCollapse), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        profitAndLossTextLabel.translatesAutoresizingMaskIntoConstraints = false
        profitAndLossValueLable.translatesAutoresizingMaskIntoConstraints = false
        expandCollapseButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profitAndLossTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            profitAndLossTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            expandCollapseButton.leadingAnchor.constraint(equalTo: profitAndLossTextLabel.trailingAnchor), // Reduced spacing
                expandCollapseButton.centerYAnchor.constraint(equalTo: profitAndLossTextLabel.centerYAnchor),
                
            
            profitAndLossValueLable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            profitAndLossValueLable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: profitAndLossTextLabel.topAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
        ])
        
        heightConstraint = heightAnchor.constraint(equalToConstant: 60)
        heightConstraint.isActive = true
    }
    
    @objc private func toggleExpandCollapse() {
        isExpanded.toggle()
        
        let buttonTitle = isExpanded ? "v" : "^"
        expandCollapseButton.setTitle(buttonTitle, for: .normal)
        
        let newHeight: CGFloat = isExpanded ? 150 : 60
        
        UIView.animate(withDuration: 0.3, animations: {
            self.heightConstraint.constant = newHeight
            self.layoutIfNeeded()
        })
        
        tableView.isHidden = !isExpanded
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpendedFooterTableViewCell", for: indexPath) as? ExpendedFooterTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            cell.configureCell(investmentText: investmentResult?.totalCurrentValue ?? "", amountText: "Current Value:")
        case 1:
            cell.configureCell(investmentText: investmentResult?.totalInvestment ?? "", amountText: "Total Investment:")
        case 2:
            cell.configureCell(investmentText: investmentResult?.todaysProfitAndLoss ?? "", amountText: "Today's Profit & Loss:")
        default:
            print("INVALID - INDEXPATH")
        }

        return  cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}
