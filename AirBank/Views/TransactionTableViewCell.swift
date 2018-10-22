//
//  TransactionTableViewCell.swift
//  AirBank
//
//  Created by Tom Kraina on 21/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var directionImageView: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!

    // MARK: - UIView lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        amountLabel.font = .transactionAmount
        directionLabel.font = .transactionDirection
        amountLabel.textColor = Asset.darkGrayText.color
        directionLabel.textColor = Asset.lightGrayText.color
        
        accessoryType = .disclosureIndicator
    }
    
}
