//
//  Identifier.swift
//  AirBank
//
//  Created by Tom Kraina on 20/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation

// Inspired by: https://www.swiftbysundell.com/posts/type-safe-identifiers-in-swift

protocol Identifiable {
    associatedtype RawIdentifier: Codable = Int
    
    var id: Identifier<Self> { get }
}

struct Identifier<Value: Identifiable> {
    let rawValue: Value.RawIdentifier
    
    init(rawValue: Value.RawIdentifier) {
        self.rawValue = rawValue
    }
}

extension Identifier: Codable where Value.RawIdentifier == Int {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        rawValue = try container.decode(Int.self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

extension Identifier: ExpressibleByIntegerLiteral
where Value.RawIdentifier == Int {
    typealias IntegerLiteralType = Int
    
    init(integerLiteral value: Int) {
        rawValue = value
    }
}
