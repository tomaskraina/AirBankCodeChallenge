//
//  Fonts.swift
//  AirBank
//
//  Created by Tom Kraina on 22/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit

extension UIFont {
    static var transactionAmount: UIFont {
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont.preferredFont(forTextStyle: .headline).withSize(20))
    }
    
    static var transactionDirection: UIFont {
        return UIFont.preferredFont(forTextStyle: .subheadline)
    }
}
