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
        let endpoint = AirBankEndpoint.transactionList
        Networking.shared.request(endpoint: endpoint) { (result: Result<TransactionListResponse>) in
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
}
