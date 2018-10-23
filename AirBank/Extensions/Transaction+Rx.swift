//
//  Transaction+Rx.swift
//  AirBank
//
//  Created by Tom Kraina on 23/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import RxDataSources

extension Transaction: IdentifiableType {
    
    typealias Identity = Int
    
    public var identity: Int {
        return id.rawValue
    }
}
