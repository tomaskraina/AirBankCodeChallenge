//
//  ContraAccountView.swift
//  AirBank
//
//  Created by Tom Kraina on 21/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit

final class CaptionValueLabelPairView: UIStackView {
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyStyling()
    }
    
    private func applyStyling() {
        captionLabel.font = captionFont
        valueLabel.font = valueFont
        captionLabel.textColor = Asset.darkGrayText.color
        valueLabel.textColor = Asset.darkGrayText.color
    }
    
    var captionFont: UIFont = UIFont.preferredFont(forTextStyle: .body) {
        didSet {
            applyStyling()
        }
    }
    
    var valueFont: UIFont = UIFont.preferredFont(forTextStyle: .body).bold() {
        didSet {
            applyStyling()
        }
    }
}

final class ContraAccountView: UIView {
    
    @IBOutlet weak var accountNumberView: CaptionValueLabelPairView!
    @IBOutlet weak var accountNameView: CaptionValueLabelPairView!
    @IBOutlet weak var bankCodeView: CaptionValueLabelPairView!
    
    // MARK: - UIView lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setupNib()
        
        accountNumberView.captionLabel.text = L10n.Account.Number.caption
        accountNameView.captionLabel.text = L10n.Account.Name.caption
        bankCodeView.captionLabel.text = L10n.Account.BankCode.caption
    }
}
