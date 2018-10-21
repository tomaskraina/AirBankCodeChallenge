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
        
        // TODO: Styling
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
        
        // Set up after view hierarchy is load from nib
        
        // TODO: Padding in stack view
    }

}
