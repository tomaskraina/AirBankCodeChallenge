//
//  AirBankIntegrationTests.swift
//  AirBankIntegrationTests
//
//  Created by Tom Kraina on 19/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import XCTest
@testable import AirBank

class AirBankIntegrationTests: XCTestCase {

    func testRequestTransactionList() {
        
        let expectation = self.expectation(description: "Response received")
        ApiClient.init(networking: Networking.shared).requestTransactionList { (result) in
            
            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)

            case .success(let value):
                XCTAssertGreaterThan(value.items.count, 0)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 100)
    }
    
    func testRequestTransactionDetails() {
        
        let expectation = self.expectation(description: "Response received")
        ApiClient.init(networking: Networking.shared).requestTransactionDetails(id: 1) { result in
        
            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)
                
            case .success:
                break
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 100)
    }
}
