//
//  ViewController.swift
//  StockTradingAppDemo
//
//

import UIKit

class ViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView()
    let headerView = UIView()
    let tableContainerView = UIView()
    
    var stockData = StockData()
    private var userHoldings: [UserHolding]?
    var bottomFooterView = BottomFooterView()
    private var viewModel: ViewControllerProtocol = ViewControllerViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        getdata()
        setupTableView()
        setupBottomFooterView()
        setupHeaderView()
        //        setupView()
    }
    
    func setupView() {
        tableContainerView.backgroundColor = .lightGray
        tableContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableContainerView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UserHoldingTableViewCell.self, forCellReuseIdentifier: Constants.XibName.userHoldingTableViewCell)
        tableContainerView.addSubview(tableView)
        // Configure the header view
        headerView.backgroundColor = .blue
        headerView.translatesAutoresizingMaskIntoConstraints = false
        tableContainerView.addSubview(headerView)
        
        tableContainerView.addSubview(bottomFooterView)
        
        // Disable autoresizing mask translation for Auto Layout
        bottomFooterView.translatesAutoresizingMaskIntoConstraints = false
        // Add constraints for the container view
        NSLayoutConstraint.activate([
            tableContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: headerView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor),
            
            headerView.topAnchor.constraint(equalTo: tableContainerView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            headerView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            
            bottomFooterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomFooterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomFooterView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor,constant: -20),
            
        ])
    }
    
    func setupTableView() {
        tableContainerView.backgroundColor = .lightGray
        tableContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableContainerView)
        
        // Add constraints for the container view
        NSLayoutConstraint.activate([
            tableContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        // Configure the table view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UserHoldingTableViewCell.self, forCellReuseIdentifier: Constants.XibName.userHoldingTableViewCell)
        tableContainerView.addSubview(tableView)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        // Add constraints for the table view inside the container
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor)
        ])
    }
    private func setupHeaderView() {
        // Configure the header view
        headerView.backgroundColor = UIColor(red: 19/255, green: 51/255, blue: 97/255, alpha: 1)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.layer.borderColor = UIColor.gray.cgColor
        headerView.layer.borderWidth = 0.5
        view.addSubview(headerView)
        
        let imageView1 = UIImageView()
        imageView1.image = UIImage(systemName: "person.circle") // Use your own image here
        imageView1.contentMode = .scaleAspectFit
        imageView1.tintColor = .white
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(imageView1)
        
        // Create label
        let label = UILabel()
        label.text = "Portfolio"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        
        // Create second image view
        let imageView2 = UIImageView()
        imageView2.image = UIImage(named: "updown") // Use your own image here
        imageView2.contentMode = .scaleAspectFit
        imageView2.tintColor = .white
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(imageView2)
        
        // Create third image view
        let imageView3 = UIImageView()
        imageView3.image = UIImage(systemName: "magnifyingglass") // Use your own image here
        imageView3.contentMode = .scaleAspectFit
        imageView3.tintColor = .white
        imageView3.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(imageView3)
        
        // Add constraints for the elements
        NSLayoutConstraint.activate([
            // Image 1 constraints
            imageView1.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            imageView1.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            imageView1.widthAnchor.constraint(equalToConstant: 25),
            imageView1.heightAnchor.constraint(equalToConstant: 25),
            
            // Label constraints
            label.leadingAnchor.constraint(equalTo: imageView1.trailingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            // Image 2 constraints
            imageView2.trailingAnchor.constraint(equalTo: imageView3.leadingAnchor, constant: -30),
            imageView2.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            imageView2.widthAnchor.constraint(equalToConstant: 20),
            imageView2.heightAnchor.constraint(equalToConstant: 20),
            
            // Image 3 constraints
            imageView3.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            imageView3.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            imageView3.widthAnchor.constraint(equalToConstant: 20),
            imageView3.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        
        
        let button1 = UIButton(type: .system)
        button1.setTitle("POSITIONS", for: .normal)
        button1.backgroundColor = .white
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        button1.setTitleColor(.gray, for: .normal)
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.addTarget(self, action: #selector(button1Tapped), for: .touchUpInside)
        
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12, weight: .bold),
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .baselineOffset: 12 ]
        let attributedString = NSMutableAttributedString(string:"")
        
        let buttonTitleStr = NSMutableAttributedString(string:"HOLDINGS", attributes:attrs)
        attributedString.append(buttonTitleStr)
        let button2 = UIButton(type: .system)
        button2.setAttributedTitle(attributedString, for: .normal)
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        button2.backgroundColor = .white
        button2.setTitleColor(.black, for: .normal)
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.addTarget(self, action: #selector(button2Tapped), for: .touchUpInside)
        headerView.addSubview(button1)
        headerView.addSubview(button2)
        NSLayoutConstraint.activate([
            // Button 1 constraints
            button1.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            button1.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            button1.trailingAnchor.constraint(equalTo: headerView.centerXAnchor),
            button1.heightAnchor.constraint(equalToConstant: 50),
            
            // Button 2 constraints
            button2.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            button2.leadingAnchor.constraint(equalTo: headerView.centerXAnchor),
            button2.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            button2.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add constraints for the header view
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 150),
            headerView.bottomAnchor.constraint(equalTo: tableView.topAnchor)// Adjust the height as needed
            
        ])
    }
    @objc private func button1Tapped() {
        print("Button 1 tapped")
    }
    
    @objc private func button2Tapped() {
        print("Button 2 tapped")
    }
    private func setupBottomFooterView() {
        // Add bottomFooterView to the main view
        tableContainerView.addSubview(bottomFooterView)
        
        // Disable autoresizing mask translation for Auto Layout
        bottomFooterView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints
        NSLayoutConstraint.activate([
            bottomFooterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomFooterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomFooterView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor,constant: 0),
        ])
    }
    private func fetchArticles() {
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.bottomFooterView.bindDataToExpendedView(for: self?.viewModel.getInvestmentResult() ?? InvestmentResult(totalCurrentValue: "", totalInvestment: "", totalProfitAndLoss: "", todaysProfitAndLoss: ""))
                self?.tableView.reloadData()
            }
        }
        viewModel.fetchStock()
    }
    func getdata() {
        fetchJSON(from: "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/", decodeType: StockData.self) { result in
            switch result {
            case .success(let item):
                DispatchQueue.main.async {
                    self.stockData = item
                    self.userHoldings = item.data?.userHolding
                    self.bottomFooterView.bindDataToExpendedView(for: self.getInvestmentResult() ?? InvestmentResult(totalCurrentValue: "", totalInvestment: "", totalProfitAndLoss: "", todaysProfitAndLoss: ""))
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error:", error)
            }
        }
    }
    
    
    
    
    
    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockData.data?.userHolding.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.XibName.userHoldingTableViewCell, for: indexPath) as? UserHoldingTableViewCell else {
            return UITableViewCell()
        }
        cell.userHoldingdata = stockData.data?.userHolding[indexPath.row]
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension ViewController {
    
    func fetchJSON<T: Decodable>(from urlString: String, decodeType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        // Check if URL is valid
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Create a URL session data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for an error
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check the response code
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code:", httpResponse.statusCode)
            }
            
            // Parse the JSON data using JSONDecoder
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(decodeType, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        // Start the task
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
