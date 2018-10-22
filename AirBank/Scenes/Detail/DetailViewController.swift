//
//  DetailViewController.swift
//  AirBank
//
//  Created by Tom Kraina on 19/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var directionImageView: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var contraAccountView: ContraAccountView!
    
    
    // MARK: - Configuration
    
    var viewModel: DetailViewModel? {
        didSet {
            setupBinding()
            viewModel?.reloadTransactionDetails()
        }
    }
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("title.detail", comment: "Title on the 'Detail' scene.")
        
        setupBinding()
        viewModel?.reloadTransactionDetails()
    }

    // MARK: - Helpers

    private func setupBinding() {
        guard isViewLoaded else { return }
        
        directionLabel.text = viewModel?.directionString
        directionImageView.image = viewModel?.directionImage
        amountLabel.text = viewModel?.amountFormatted
        
        viewModel?.onContraAccountUpdate = { [weak self] in
            self?.contraAccountView.accountNameView.valueLabel.text = self?.viewModel?.contraAccountInfo?.accountName
            self?.contraAccountView.accountNumberView.valueLabel.text = self?.viewModel?.contraAccountInfo?.accountNumber
            self?.contraAccountView.bankCodeView.valueLabel.text = self?.viewModel?.contraAccountInfo?.bankCode
            
            // TODO: Move this logic to ViewModel
            let state: State
            if self?.viewModel?.contraAccountInfo != nil {
                state = .loaded
            } else if self?.viewModel?.isLoadingTransactionDetails == true {
                state = .loading
            } else {
                state = .empty
            }
            
            self?.configure(state: state)
        }
        
        viewModel?.onError = { [weak self] error in
            guard let self = self else { return }
            guard self.view.window != nil else { return }
            
            let alert = UIAlertController.makeAlert(error: error, retryHandler: {
                self.viewModel?.reloadTransactionDetails()
            })
            self.present(alert, animated: true)
        }
    }
    
    enum State {
        case empty
        case loading
        case loaded
    }
    
    private func configure(state: State) {
        switch state {
        case .empty:
            loadingView.isHidden = true
            contraAccountView.isHidden = true
        case .loading:
            loadingView.isHidden = false
            contraAccountView.isHidden = true
        case .loaded:
            loadingView.isHidden = true
            contraAccountView.isHidden = false
        }
    }
}
