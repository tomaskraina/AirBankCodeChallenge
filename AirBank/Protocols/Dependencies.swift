//
//  Dependencies.swift
//  AirBank
//
//  Created by Tom Kraina on 22/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation

// Inspired by: http://merowing.info/2017/04/using-protocol-compositon-for-dependency-injection/

protocol HasApiClient {
    var apiClient: ApiClient { get }
}

protocol HasCurrencyFormatter {
    var currencyFormatter: NumberFormatter { get }
}
