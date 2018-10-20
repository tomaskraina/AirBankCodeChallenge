//
//  TransactionDetailDecodableTests.swift
//  AirBankTests
//
//  Created by Tom Kraina on 20/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import XCTest
@testable import AirBank

class TransactionDetailDecodableTests: XCTestCase {

    func testDecodeStandardDetail() throws {
        let json = """
            {"id": 1,"amountInAccountCurrency": 1056,"direction": "INCOMING"}
        """.data(using: .utf8)!
        
        let detail = try JSONDecoder().decode(TransactionDetail.self, from: json)
        
        XCTAssertEqual(detail.id.rawValue, 1)
        XCTAssertEqual(detail.amountInAccountCurrency, 1056)
        XCTAssertEqual(detail.direction, .incoming)
    }
}
