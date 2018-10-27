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
    
    var isContraAccountShown: Observable<Bool> { get }
    var contraAccountNumber: Observable<String> { get }
    var contraAccountName: Observable<String> { get }
    var contraBankCode: Observable<String> { get }
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
    
    var isContraAccountShown: Observable<Bool> {
        return contraAccountInfo.asObservable().map{ $0 != nil }
    }
    
    var contraAccountNumber: Observable<String> {
        return contraAccountInfo.asObservable().map{ $0?.accountNumber ?? "" }
    }
    
    var contraAccountName: Observable<String> {
        return contraAccountInfo.asObservable().map{ $0?.accountName ?? "" }
    }
    
    var contraBankCode: Observable<String> {
        return contraAccountInfo.asObservable().map{ $0?.bankCode ?? "" }
    }
    
    let error = PublishSubject<Error>()
    
    func reloadTransactionDetails() {
        // Don't fire multiple requests at once, either cancel previous or ignore the subsequent
        guard isLoadingTransactionDetails.value == false else { return }
        
        isLoadingTransactionDetails.value = true
        apiClient.requestTransactionDetails(id: transaction.id)
            .debug("detail")
            .observeOn(MainScheduler())
            .do(onError: { [weak self] (error) in
                self?.error.onNext(error)
                }, onDispose: { [weak self] in
                    self?.isLoadingTransactionDetails.value = false
            })
            .map({ $0.contraAccount })
            .bind(to: contraAccountInfo)
            .disposed(by: disposeBag)
    }
    
    var inputs: DetailViewModelInputs { return self }
    
    var outputs: DetailViewModelOutputs { return self }
    
    // MARK: - Helpers

    private let disposeBag = DisposeBag()
    
    private let contraAccountInfo: Variable<ContraAccount?> = .init(nil)
}
