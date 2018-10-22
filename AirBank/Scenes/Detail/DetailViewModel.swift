//
//  DetailViewModel.swift
//  AirBank
//
//  Created by Tom Kraina on 21/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import class UIKit.UIImage

class DetailViewModel {
    
    let transaction: Transaction
    
    let apiClient: ApiClient
    
    init(transaction: Transaction, apiClient: ApiClient) {
        self.transaction = transaction
        self.apiClient = apiClient
    }
    
    var isLoadingTransactionDetails: Bool = false {
        didSet {
            onLoadingTransactionDetailsUpdate?()
        }
    }
    
    var onLoadingTransactionDetailsUpdate: (() -> Void)?
    
    var amountFormatted: String? {
        // TODO: CurrencyFormatter
        return String(transaction.amountInAccountCurrency)
    }
    
    var directionString: String? {
        return transaction.direction.localizedString
    }
    
    var directionImage: UIImage? {
        return transaction.direction.image
    }
    
    var contraAccountInfo: ContraAccount? {
        didSet {
            onContraAccountUpdate?()
        }
    }
    
    var onContraAccountUpdate: (() -> Void)? {
        didSet {
            onContraAccountUpdate?()
        }
    }
    
    var onError: ((Error) -> Void)?
    
    func reloadTransactionDetails() {
        isLoadingTransactionDetails = true
        
        apiClient.requestTransactionDetails(id: transaction.id) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                self.contraAccountInfo = value.contraAccount
            case .failure(let error):
                self.onError?(error)
            }
            
            self.isLoadingTransactionDetails = false
        }
    }
}
