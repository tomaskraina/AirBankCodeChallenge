//
//  TransactionDetailsResponseDecodableTests.swift
//  AirBankTests
//
//  Created by Tom Kraina on 20/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import XCTest
@testable import AirBank

class TransactionDetailsResponseDecodableTests: XCTestCase {

    func testDecodeStandardDetails() throws {
        let json = """
            {
              "contraAccount": {
                "accountNumber": "111",
                "accountName": "BU",
                "bankCode": "3030"
              }
            }
        """.data(using: .utf8)!
        
        let response = try JSONDecoder().decode(TransactionDetailsResponse.self, from: json)
        
        XCTAssertEqual(response.contraAccount.accountName, "BU")
        XCTAssertEqual(response.contraAccount.accountNumber, "111")
        XCTAssertEqual(response.contraAccount.bankCode, "3030")
    }

}
