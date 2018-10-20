//
//  AirBankEndpoint.swift
//  AirBank
//
//  Created by Tom Kraina on 20/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Alamofire

// Inspired by: http://chris.eidhof.nl/posts/typesafe-url-routes-in-swift.html

// MARK: - Protocols

public protocol Path {
    var path : String { get }
}

public protocol Endpoint: Path, URLConvertible {
    var baseURL: URL { get }
    var method: Alamofire.HTTPMethod { get }
    var parameters: [String: Any]? { get }
}

// MARK: - Endpoint + default implementation
extension Endpoint {
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    func asURL() throws -> URL {
        guard let url = URL(string: path, relativeTo: baseURL) else { throw AFError.invalidURL(url: self) }
        return url
    }
}

// MARK: - AirBankEndpoint

enum AirBankEndpoint {
    case transactionList
    case transactionDetails(id: Identifier<Transaction>)
}

// MARK: - AirBankEndpoint+Endpoint
extension AirBankEndpoint: Endpoint {
    
    var baseURL: URL {
        return URL(string: "https://demo0569565.mockable.io/")!
    }
    
    var path: String {
        switch self {
        case .transactionList:
            return "transactions"
            
        case let .transactionDetails(id):
            return "transactions/\(id.rawValue)"
        }
    }
}
