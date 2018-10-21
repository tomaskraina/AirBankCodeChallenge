//
//  ApiClient.swift
//  AirBank
//
//  Created by Tom Kraina on 21/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation

class ApiClient {
    
    init(networking: NetworkingProvider) {
        self.networking = networking
    }
    
    let networking: NetworkingProvider
    
    @discardableResult
    func requestTransactionList(completion: @escaping (Result<TransactionListResponse>) -> Void) -> DataRequest {
        let endpoint = AirBankEndpoint.transactionList
        return networking.request(endpoint: endpoint, completion: completion)
    }
    
    @discardableResult
    func requestTransactionDetails(id: Identifier<Transaction>, completion: @escaping (Result<TransactionDetailsResponse>) -> Void) -> DataRequest {
        let endpoint = AirBankEndpoint.transactionDetails(id: id)
        return networking.request(endpoint: endpoint, completion: completion)
    }
}
