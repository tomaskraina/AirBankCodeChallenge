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
        let title = NSLocalizedString("error.network.title", comment: "Title on error alert.")
        let message = error.localizedDescription
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("error.network.cancel", comment: "Cancel button title on error alert."), style: .cancel, handler: nil))
        
        if let retryHandler = retryHandler {
            alert.addAction(UIAlertAction(title: NSLocalizedString("error.network.retry", comment: "Cancel button title on error alert."), style: .default, handler: { _ in
                retryHandler()
            }))
        }
        
        return alert
    }
}
