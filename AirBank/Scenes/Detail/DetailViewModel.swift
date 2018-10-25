//
//  DetailViewModel.swift
//  AirBank
//
//  Created by Tom Kraina on 21/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import class UIKit.UIImage
import RxSwift

protocol DetailViewModelInputs {
    func reloadTransactionDetails()
}

protocol DetailViewModelOutputs {
    var isLoadingTransactionDetails: Variable<Bool> { get }
    var amountFormatted: Variable<String> { get }
    var directionString: Variable<String> { get }
    var directionImage: Variable<UIImage> { get }
    
    var error: PublishSubject<Error> { get }
    
    var isContraAccountShown: Variable<Bool> { get }
    var contraAccountNumber: Variable<String> { get }
    var contraAccountName: Variable<String> { get }
    var contraBankCode: Variable<String> { get }
}

protocol DetailViewModelling {
    var inputs: DetailViewModelInputs { get }
    var outputs: DetailViewModelOutputs { get }
}

class DetailViewModel: DetailViewModelling, DetailViewModelInputs, DetailViewModelOutputs {
    
    typealias Dependencies = HasApiClient & HasCurrencyFormatter
    
    enum State {
        case empty
        case loading
        case loaded
    }
    
    let transaction: Transaction
    
    let apiClient: ApiClient
    
    let currencyFormatter: NumberFormatter

    init(transaction: Transaction, dependencies: Dependencies) {
        self.transaction = transaction
        self.apiClient = dependencies.apiClient
        self.currencyFormatter = dependencies.currencyFormatter
        
        let amountFormatted = currencyFormatter.string(from: NSNumber(value: transaction.amountInAccountCurrency))
        self.amountFormatted = Variable(amountFormatted ?? "")
        self.directionString = Variable(transaction.direction.localizedString)
        self.directionImage = Variable(transaction.direction.image)
    }
    
    let isLoadingTransactionDetails = Variable<Bool>(false)

    let amountFormatted: Variable<String>

    let directionString: Variable<String>
    
    let directionImage: Variable<UIImage>
    
    let isContraAccountShown = Variable<Bool>(false)
    
    let contraAccountNumber = Variable<String>("")
    
    let contraAccountName = Variable<String>("")
    
    let contraBankCode = Variable<String>("")
    
    let error = PublishSubject<Error>()
    
    func reloadTransactionDetails() {
        // Don't fire multiple requests at once, either cancel previous or ignore the subsequent
        guard isLoadingTransactionDetails.value == false else { return }
        
        isLoadingTransactionDetails.value = true
        apiClient.requestTransactionDetails(id: transaction.id) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                self.contraAccountInfo = value.contraAccount
            case .failure(let error):
                self.error.onNext(error)
            }
            
            self.isLoadingTransactionDetails.value = false
        }
    }
    
    var inputs: DetailViewModelInputs { return self }
    
    var outputs: DetailViewModelOutputs { return self }
    
    // MARK: - Helpers

    private var contraAccountInfo: ContraAccount? {
        didSet {
            contraAccountName.value = contraAccountInfo?.accountName ?? ""
            contraAccountNumber.value = contraAccountInfo?.accountNumber ?? ""
            contraBankCode.value = contraAccountInfo?.bankCode ?? ""
            isContraAccountShown.value = contraAccountInfo != nil
        }
    }
}
