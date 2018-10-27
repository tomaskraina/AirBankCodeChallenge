//
//  ApiClient.swift
//  AirBank
//
//  Created by Tom Kraina on 21/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import RxSwift

class ApiClient {
    
    init(networking: NetworkingProvider) {
        self.networking = networking
    }
    
    let networking: NetworkingProvider
    
    @discardableResult
    func requestTransactionList() -> Observable<TransactionListResponse> {
        let endpoint = AirBankEndpoint.transactionList
        return networking.request(endpoint: endpoint)
    }
    
    @discardableResult
    func requestTransactionDetails(id: Identifier<Transaction>) -> Observable<TransactionDetailsResponse> {
        let endpoint = AirBankEndpoint.transactionDetails(id: id)
        return networking.request(endpoint: endpoint)
    }
}
