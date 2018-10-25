//
//  ListViewModel.swift
//  AirBank
//
//  Created by Tom Kraina on 21/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import class UIKit.UIImage
import RxSwift
import RxDataSources

enum ListFilterSetting {
    case all
    case incomingTransactions
    case outgoingTransactions
}

protocol ListViewModelling: AnyObject {
    func updateFilter(setting: ListFilterSetting)
    var filterSetting: Variable<ListFilterSetting> { get }
    var error: PublishSubject<Error> { get }
    var isLoading: Variable<Bool> { get }
    
    func reload()
    
    func image(for item: Transaction) -> UIImage?
    func title(for item: Transaction) -> String?
    func subtitle(for item: Transaction) -> String?
    
    var tableContents: Observable<[SectionModel<Int, Transaction>]> { get }
}

class ListViewModel: ListViewModelling {

    typealias Dependencies = HasApiClient & HasCurrencyFormatter
    
    let apiClient: ApiClient
    
    let currencyFormatter: NumberFormatter
    
    let filterSetting = Variable<ListFilterSetting>(.all)
    
    let error = PublishSubject<Error>()
    
    let isLoading = Variable<Bool>(false)
    
    let items: Observable<[Transaction]>
    
    init(dependencies: Dependencies) {
        self.apiClient = dependencies.apiClient
        self.currencyFormatter = dependencies.currencyFormatter
        
        items = Observable<[Transaction]>.combineLatest(unfilteredItems.asObservable(), filterSetting.asObservable()) { (items, setting) -> [Transaction] in
            filter(items: items, setting: setting)
        }
    }
    
    func updateFilter(setting: ListFilterSetting) {
        filterSetting.value = setting
    }
    
    func reload() {
        // Don't fire multiple requests at once, either cancel previous or ignore the subsequent
        guard isLoading.value == false else { return }
        
        isLoading.value = true
        apiClient.requestTransactionList { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading.value = false
            
            switch result {
            case .success(let value):
                self.unfilteredItems.value = value.items
                
            case .failure(let error):
                self.error.onNext(error)
            }
        }
    }
    
    func image(for item: Transaction) -> UIImage? {
        return item.direction.image
    }
        
    func title(for item: Transaction) -> String? {
        return currencyFormatter.string(from: NSNumber(value: item.amountInAccountCurrency))
    }
    
    func subtitle(for item: Transaction) -> String? {
        return item.direction.localizedString
    }
    
    var tableContents: Observable<[SectionModel<Int, Transaction>]> {
        return items.map() {
            [SectionModel(model: 0, items: $0)]
        }
    }
    
    // MARK: - Privates
    
    private let disposeBag = DisposeBag()
    
    private let unfilteredItems = Variable<[Transaction]>([])
}

// MARK: - functions

private func filter(items: [Transaction], setting: ListFilterSetting) -> [Transaction] {
    switch setting {
    case .all:
        return items
    case .incomingTransactions:
        return items.filter { $0.direction == .incoming }
    case .outgoingTransactions:
        return items.filter { $0.direction == .outgoing }
    }
}


// MARK: - TransactionDirection+image
extension TransactionDirection {
    var image: UIImage {
        switch self {
        case .incoming:
            return Asset.arrowRight.image
        case .outgoing:
            return Asset.arrowLeft.image
        }
    }
}

// MARK: - TransactionDirection+localizedString
extension TransactionDirection {
    var localizedString: String {
        switch self {
        case .incoming:
            return L10n.Transaction.incoming
        case .outgoing:
            return L10n.Transaction.outgoing
        }
    }
}
