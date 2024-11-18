//
//  StockTradingDemoAppTests.swift
//  StockTradingDemoAppTests
//

import XCTest
@testable import StockTradingDemoApp

final class  ViewControllerViewModelTests: XCTestCase {
    
    var viewModel: ViewControllerViewModel!
    var mockUserHoldings: [UserHolding]!
    var url = "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/"
    
    
    override func setUp() {
        super.setUp()
        
        // Initialize the view model and mock data
        viewModel = ViewControllerViewModel()
        mockUserHoldings = [
            UserHolding(symbol: "TATA", quantity: 10, ltp: 10.0, avgPrice: 200.0, close: 100.0),
            UserHolding(symbol: "MAHINDRA", quantity: 5, ltp: 210.0, avgPrice: 100.0, close: 200.0)
        ]
         
        
    }
    
    override func tearDown() {
        viewModel = nil
        mockUserHoldings = nil
        MockURLProtocol.responseData = nil
        MockURLProtocol.responseError = nil

        super.tearDown()
    }
    
    func testNumberOfUserStocks() {
        viewModel.userHoldings = mockUserHoldings
        XCTAssertEqual(viewModel.numberOfUserStocks(), mockUserHoldings.count, "Number of user stocks should match the count of mock data")
    }
    
    func testUserStocksAtIndex() {
        viewModel.userHoldings = mockUserHoldings
        let index = 1
        let userStock = viewModel.UserStocks(at: index)
        XCTAssertEqual(userStock?.currentValue, mockUserHoldings[index].currentValue, "User stock at index should match mock data")
    }
    
    func testGetInvestmentResult() {
        viewModel.userHoldings = mockUserHoldings
        let result = viewModel.getInvestmentResult()
        
        // Expected calculations
        let expectedTotalCurrentValue = "₹1150.00"
        let expectedTotalInvestment = "₹2500.00"
        let expectedTodaysProfitAndLoss = "₹-1350.00"
        let expectedTotalProfitAndLoss = "₹850.00"
        
        XCTAssertEqual(result?.totalCurrentValue, expectedTotalCurrentValue, "Total current value should match expected")
        XCTAssertEqual(result?.totalInvestment, expectedTotalInvestment, "Total investment should match expected")
        XCTAssertEqual(result?.todaysProfitAndLoss, expectedTodaysProfitAndLoss, "Today's profit and loss should match expected")
        XCTAssertEqual(result?.totalProfitAndLoss, expectedTotalProfitAndLoss, "Total profit and loss should match expected")
    }
    
    
    func testFetchJSONSuccess() {
           let expectation = XCTestExpectation(description: "Fetch JSON success")

        viewModel.fetchJSON(from: url, decodeType: StockData.self) { result in
               switch result {
               case .success(let decodedData):
                   XCTAssertEqual(decodedData.data?.userHolding[0].symbol, "MAHABANK")
               case .failure:
                   XCTFail("Expected success but received failure")
               }
               expectation.fulfill()
           }
           
           wait(for: [expectation], timeout: 1)
       }

       func testFetchJSONFailureWithError() {
           // Simulate an error
           MockURLProtocol.responseError = NSError(domain: "NetworkError", code: -1, userInfo: nil)

           let expectation = XCTestExpectation(description: "Fetch JSON error")
           
           viewModel.fetchJSON(from: url, decodeType: String.self) { result in
               switch result {
               case .success:
                   XCTFail("Expected failure but received success")
               case .failure(let error):
                   XCTAssertEqual((error as NSError).domain, "NSCocoaErrorDomain")
               }
               expectation.fulfill()
           }
           
           wait(for: [expectation], timeout: 1)
       }

       func testFetchJSONFailureWithInvalidData() {
           // Set up invalid JSON data
           let invalidJsonData = "Invalid JSON".data(using: .utf8)
           MockURLProtocol.responseData = invalidJsonData
           MockURLProtocol.responseCode = 200

           let expectation = XCTestExpectation(description: "Fetch JSON invalid data")
           
           viewModel.fetchJSON(from: url, decodeType: String.self) { result in
               switch result {
               case .success:
                   XCTFail("Expected failure due to invalid JSON data")
               case .failure:
                   // Expecting a decoding error
                   XCTAssertTrue(true)
               }
               expectation.fulfill()
           }
           
           wait(for: [expectation], timeout: 1)
       }

}

class MockURLProtocol: URLProtocol {
    // Properties to simulate responses
    static var responseData: Data?
    static var responseError: Error?
    static var responseCode: Int = 200

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        // Simulate a response with a status code and optional data/error
        if let error = MockURLProtocol.responseError {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            let httpResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: MockURLProtocol.responseCode,
                httpVersion: nil,
                headerFields: nil
            )
            client?.urlProtocol(self, didReceive: httpResponse!, cacheStoragePolicy: .notAllowed)
            
            if let data = MockURLProtocol.responseData {
                client?.urlProtocol(self, didLoad: data)
            }
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
