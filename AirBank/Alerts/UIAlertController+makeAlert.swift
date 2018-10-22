//
//  UIAlertController+makeAlert.swift
//  AirBank
//
//  Created by Tom Kraina on 22/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    static func makeAlert(error: Error, retryHandler: (() -> Void)?) -> UIAlertController {
        let title = L10n.Error.Network.title
        let message = error.localizedDescription
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Error.Network.cancel, style: .cancel, handler: nil))
        
        if let retryHandler = retryHandler {
            alert.addAction(UIAlertAction(title: L10n.Error.Network.retry, style: .default, handler: { _ in
                retryHandler()
            }))
        }
        
        return alert
    }
}
