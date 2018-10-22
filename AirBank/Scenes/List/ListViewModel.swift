//
//  ListViewModel.swift
//  AirBank
//
//  Created by Tom Kraina on 21/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import class UIKit.UIImage

protocol ListViewModelling: AnyObject {
    var items: [Transaction] { get }
    var onItemsUpdate: (([Transaction]) -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    
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
    
    init(dependencies: Dependencies) {
        self.apiClient = dependencies.apiClient
        self.currencyFormatter = dependencies.currencyFormatter
    }
    
    private(set) var items: [Transaction] = [] {
        didSet {
            onItemsUpdate?(items)
        }
    }
    
    var onItemsUpdate: (([Transaction]) -> Void)?
    
    var onError: ((Error) -> Void)?
    
    func reload() {
        apiClient.requestTransactionList { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                self.items = value.items
                
            case .failure(let error):
                self.onError?(error)
            }
        }
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func image(at index: Int) -> UIImage? {
        let item = items[index]
        return item.direction.image
    }
    
    func title(at index: Int) -> String? {
        let item = items[index]
        return currencyFormatter.string(from: NSNumber(value: item.amountInAccountCurrency))
    }
    
    func subtitle(at index: Int) -> String? {
        let item = items[index]
        return item.direction.localizedString
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
            return NSLocalizedString("transaction.INCOMING", comment: "Text for an incoming direction")
        case .outgoing:
            return NSLocalizedString("transaction.OUTGOING", comment: "Text for an outgoing direction")
        }
    }
}
