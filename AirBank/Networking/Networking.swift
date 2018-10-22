//
//  Networking.swift
//  AirBank
//
//  Created by Tom Kraina on 20/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Alamofire
import CodableAlamofire

// MARK: - Protocols

protocol NetworkingProvider {
    @discardableResult
    func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T>) -> Void) -> DataRequest
}

// MARK: - Networking

class Networking: NetworkingProvider {
    
    static let shared = Networking(manager: .default)
    
    init(manager: SessionManager) {
        self.manager = manager
    }
    
    let manager: SessionManager
    
    @discardableResult
    func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T>) -> Void) -> DataRequest {
        
        let dataRequest = manager.request(endpoint, method: endpoint.method, parameters: endpoint.parameters)
        dataRequest.responseDecodableObject { (dataResponse: DataResponse<T>) in
            
            switch dataResponse.result {
            case .success(let value):
                completion(.success(value))
                
            case .failure(let error):
                let networkingError = NetworkingError.init(error: error, httpUrlResponse: dataResponse.response)
                completion(.failure(networkingError))
            }
        }
    
        dataRequest.resume()
        return dataRequest
    }
}
