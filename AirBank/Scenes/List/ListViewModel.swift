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

enum ListFilterSetting {
    case all
    case incomingTransactions
    case outgoingTransactions
}

protocol ListViewModelling: AnyObject {
    func updateFilter(setting: ListFilterSetting)
    var filterSetting: Variable<ListFilterSetting> { get }
    var items: Variable<[Transaction]> { get }
    var error: PublishSubject<Error> { get }
    var isLoading: Variable<Bool> { get }
    
    func reload()
    
    func numberOfItems() -> Int
    func image(at index: Int) -> UIImage?
    func title(at index: Int) -> String?
    func subtitle(at index: Int) -> String?
}

class ListViewModel: ListViewModelling {
    
    typealias Dependencies = HasApiClient & HasCurrencyFormatter
    
    let apiClient: ApiClient
    
    let currencyFormatter: NumberFormatter
    
    let filterSetting = Variable<ListFilterSetting>(.all)
    
    let error = PublishSubject<Error>()
    
    let isLoading = Variable<Bool>(false)
    
    let items = Variable<[Transaction]>([])
    
    init(dependencies: Dependencies) {
        self.apiClient = dependencies.apiClient
        self.currencyFormatter = dependencies.currencyFormatter
        
        unfilteredItems.asObservable().map {
            filter(items: $0, setting: self.filterSetting.value)
            }.subscribe(onNext: {
                self.items.value = $0
            }).disposed(by: disposeBag)
        
        filterSetting.asObservable().map {
            filter(items: self.unfilteredItems.value, setting: $0) }
            .subscribe(onNext: {
                self.items.value = $0})
            .disposed(by: disposeBag)
    }
    
    func updateFilter(setting: ListFilterSetting) {
        filterSetting.value = setting
    }
    
    func reload() {
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
    
    func numberOfItems() -> Int {
        return items.value.count
    }
    
    func image(at index: Int) -> UIImage? {
        let item = items.value[index]
        return item.direction.image
    }
    
    func title(at index: Int) -> String? {
        let item = items.value[index]
        return currencyFormatter.string(from: NSNumber(value: item.amountInAccountCurrency))
    }
    
    func subtitle(at index: Int) -> String? {
        let item = items.value[index]
        return item.direction.localizedString
    }
    
    // MARK: - Privates
    
    private let disposeBag = DisposeBag()
    
    private let unfilteredItems = Variable<[Transaction]>([])
}

// MARK: - functions

// TODO: lazy indexed sequence?
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
