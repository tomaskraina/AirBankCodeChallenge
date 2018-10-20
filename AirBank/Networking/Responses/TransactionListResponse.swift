//
//  TransactionListResponse.swift
//  AirBank
//
//  Created by Tom Kraina on 20/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation

struct TransactionListResponse: Codable {
    let items: [Transaction]
}
