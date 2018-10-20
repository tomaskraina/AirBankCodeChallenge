//
//  TransactionListResponseDecodableTests.swift
//  AirBankTests
//
//  Created by Tom Kraina on 20/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import XCTest

@testable import AirBank

class TransactionListResponseDecodableTests: XCTestCase {
    
    func testDecodeStandardDetail() throws {
        
        let response: TransactionListResponse = try JSON(named: "transactionList-success")
        XCTAssertGreaterThan(response.items.count, 0)
    }
}
