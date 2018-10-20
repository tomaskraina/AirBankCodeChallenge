//
//  helpers.swift
//  AirBankTests
//
//  Created by Tom Kraina on 20/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation

private class _AirbankTests: NSObject {}

let AirBankTestsBundle = Bundle(for: _AirbankTests.self)

func JSON<T: Decodable>(named name: String, bundle: Bundle = AirBankTestsBundle) throws -> T {
    
    let url = bundle.url(forResource: name, withExtension: "json")!
    let data = try Data(contentsOf: url)
    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        print(error)
        throw error
    }
}
