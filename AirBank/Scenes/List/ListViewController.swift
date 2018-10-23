//
//  ListViewController.swift
//  AirBank
//
//  Created by Tom Kraina on 21/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol ListViewControllerDelegate: AnyObject {
    func list(viewController: ListViewController, didSelect item: Transaction)
}

class ListViewController: UITableViewController, LoadingPresentable {

    let disposeBag = DisposeBag()
    
    // MARK: - Configuration
    
    var viewModel: ListViewModelling? {
        didSet {
            setupBinding()
            viewModel?.reload()
        }
    }
    
    weak var delegate: ListViewControllerDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var transactionFilterView: TransactionDirectionFilterView!
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = L10n.Title.list
        tableView.register(TransactionTableViewCell.nib()!, forCellReuseIdentifier: TransactionTableViewCell.nibName())
        tableView.refreshControl = makeRefreshControl()
        transactionFilterView.delegate = self
            
        setupBinding()
    }
    
    // MARK: - IBAction
    
    @IBAction func pulledToRefresh(sender: UIRefreshControl) {
        viewModel?.reload()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            sender.endRefreshing()
        }
    }
    
    // MARK: - Helpers
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<Int, Transaction>> {
        return RxTableViewSectionedReloadDataSource<SectionModel<Int, Transaction>>(
            configureCell: { [weak self] (dataSource, tableView, indexPath, item) in
                let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.nibName(), for: indexPath)
                
                if let transactionCell = cell as? TransactionTableViewCell {
                    transactionCell.directionImageView.image = self?.viewModel?.image(at: indexPath.row)
                    transactionCell.amountLabel.text = self?.viewModel?.title(at: indexPath.row)
                    transactionCell.directionLabel.text = self?.viewModel?.subtitle(at: indexPath.row)
                }
                
                return cell
        })
    }
    
    func setupBinding() {
        guard isViewLoaded else { return }

        viewModel?.tableContents.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        tableView.rx.modelSelected(Transaction.self)
            .subscribe(onNext: { [unowned self] in
                self.delegate?.list(viewController: self, didSelect: $0) }
            ).disposed(by: disposeBag)

        viewModel?.isLoading.asObservable().subscribe(onNext: { [weak self] loading in
            // TODO: move this logic to VM
            if loading && self?.viewModel?.numberOfItems() == 0 {
                self?.showLoading()
            } else {
                self?.hideLoading()
            }
        }).disposed(by: disposeBag)
        
        viewModel?.error.asObservable().subscribe(onNext: { [weak self] error in
            guard let self = self else { return }
            // TODO: move this logic to VM
            guard self.view.window != nil else { return }
            
            let alert = UIAlertController.makeAlert(error: error, retryHandler: {
                self.viewModel?.reload()
            })
            self.present(alert, animated: true)
        }).disposed(by: disposeBag)
    }

    func makeRefreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(pulledToRefresh(sender:)),
            for: .valueChanged)
        return refreshControl
    }

}

// MARK: - ListViewController: TransactionDirectionFilterViewDelegate
extension ListViewController: TransactionDirectionFilterViewDelegate {
    func filter(view: TransactionDirectionFilterView, didSelectSegment segment: TransactionDirectionFilterView.Segment) {
        let filterSetting: ListFilterSetting
        switch segment {
        case .all:
            filterSetting = .all
        case .incoming:
            filterSetting = .incomingTransactions
        case .outgoing:
            filterSetting = .outgoingTransactions
        }
        
        viewModel?.updateFilter(setting: filterSetting)
    }
}
