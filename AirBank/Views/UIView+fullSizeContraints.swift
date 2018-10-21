//
//  UIView+fullSizeContraints.swift
//  AirBank
//
//  Created by Tom Kraina on 21/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit

extension UIView {
    public func addFullsizeConstraintsForSubview(_ view: UIView, insets: UIEdgeInsets = .zero, priority: UILayoutPriority = .required) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        let metrics = ["priority": priority]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", metrics:nil, views: bindings))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(insets.top)@priority)-[view]-(\(insets.bottom)@priority)-|", metrics:metrics, views: bindings))
    }
}
