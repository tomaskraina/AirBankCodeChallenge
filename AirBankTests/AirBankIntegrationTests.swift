//
//  AirBankIntegrationTests.swift
//  AirBankIntegrationTests
//
//  Created by Tom Kraina on 19/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import XCTest
@testable import AirBank
import RxBlocking

class AirBankIntegrationTests: XCTestCase {

    func testRequestTransactionList() throws {
        let apiClient = ApiClient.init(networking: Networking.shared)
        let result = try apiClient.requestTransactionList().toBlocking(timeout: 10).single()
        XCTAssertGreaterThan(result.items.count, 0)
    }
    
    func testRequestTransactionDetails() throws {
        let apiClient = ApiClient.init(networking: Networking.shared)
        let result = try apiClient.requestTransactionDetails(id: 1).toBlocking(timeout: 10).single()
        XCTAssertFalse(result.contraAccount.accountName.isEmpty)
    }
}
