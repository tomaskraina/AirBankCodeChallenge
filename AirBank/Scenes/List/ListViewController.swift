//
//  ListViewController.swift
//  AirBank
//
//  Created by Tom Kraina on 21/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit

protocol ListViewControllerDelegate: AnyObject {
    func list(viewController: ListViewController, didSelect item: Transaction)
}

class ListViewController: UITableViewController {

    // MARK: - Configuration
    
    var viewModel: ListViewModelling? {
        didSet {
            setupBinding()
            viewModel?.reload()
        }
    }
    
    weak var delegate: ListViewControllerDelegate?
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("title.list", comment: "Title on the 'List' scene.")
        tableView.register(TransactionTableViewCell.nib()!, forCellReuseIdentifier: TransactionTableViewCell.nibName())
        tableView.refreshControl = makeRefreshControl()
            
        setupBinding()
        viewModel?.reload()
    }
    
    // MARK: - IBAction
    
    @IBAction func pulledToRefresh(sender: UIRefreshControl) {
        viewModel?.reload()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            sender.endRefreshing()
        }
    }
    
    // MARK: - Helpers
    
    func setupBinding() {
        guard isViewLoaded else { return }
        
        // TODO: Show / hide loading
        
        viewModel?.onItemsUpdate = { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        viewModel?.onError = { [weak self] error in
            guard let self = self else { return }
            guard self.view.window != nil else { return }
            
            let alert = UIAlertController.makeAlert(error: error, retryHandler: {
                self.viewModel?.reload()
            })
            self.present(alert, animated: true)
        }
    }

    func makeRefreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(pulledToRefresh(sender:)),
            for: .valueChanged)
        return refreshControl
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfItems() ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.nibName(), for: indexPath)

        // Configure the cell...
        if let transactionCell = cell as? TransactionTableViewCell {
            transactionCell.directionImageView.image = viewModel?.image(at: indexPath.row)
            transactionCell.amountLabel.text = viewModel?.title(at: indexPath.row)
            transactionCell.directionLabel.text = viewModel?.subtitle(at: indexPath.row)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = viewModel?.items[indexPath.row] else { return }
        delegate?.list(viewController: self, didSelect: item)
    }
}
