//
//  CurrencyCode.swift
//  AirBank
//
//  Created by Tom Kraina on 22/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation

struct CurrencyCode: RawRepresentable {
    let rawValue: String
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
}
