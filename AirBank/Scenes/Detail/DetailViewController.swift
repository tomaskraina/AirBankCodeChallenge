//
//  DetailViewController.swift
//  AirBank
//
//  Created by Tom Kraina on 19/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DetailViewController: UIViewController {

    @IBOutlet weak var directionImageView: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var contraAccountView: ContraAccountView!
    
    
    // MARK: - Configuration
    
    var viewModel: DetailViewModelling? {
        didSet {
            setupBinding()
            viewModel?.reloadTransactionDetails()
        }
    }
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = L10n.Title.detail
        separatorView.backgroundColor = Asset.lightGrayText.color
        
        amountLabel.font = UIFont.transactionAmount
        directionLabel.font = .transactionDirection
        amountLabel.textColor = Asset.darkGrayText.color
        directionLabel.textColor = Asset.lightGrayText.color
        
        setupBinding()
    }

    // MARK: - Helpers

    private let disposeBag = DisposeBag()
    
    private func setupBinding() {
        guard isViewLoaded else { return }
        
        viewModel?.directionString.asObservable()
            .bind(to: directionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.directionImage.asObservable()
            .bind(to: directionImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel?.amountFormatted.asObservable()
            .bind(to: amountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.contraAccountName.asObservable()
            .bind(to: contraAccountView.accountNameView.valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.contraAccountNumber.asObservable()
            .bind(to: contraAccountView.accountNumberView.valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.contraBankCode.asObservable()
            .bind(to: contraAccountView.bankCodeView.valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.isLoadingTransactionDetails.asObservable()
            .map{ !$0 }
            .bind(to: loadingView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel?.isContraAccountShown.asObservable()
            .map{ !$0 }
            .bind(to: contraAccountView.rx.isHidden)
            .disposed(by: disposeBag)
        

        viewModel?.error.asObservable().subscribe(onNext: { [weak self] error in
            guard self?.view.window != nil else { return }
            
            let alert = UIAlertController.makeAlert(error: error, retryHandler: {
                self?.viewModel?.reloadTransactionDetails()
            })
            self?.present(alert, animated: true)
        }).disposed(by: disposeBag)
    }
}

