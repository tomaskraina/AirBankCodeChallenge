//
//  Networking.swift
//  AirBank
//
//  Created by Tom Kraina on 20/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Alamofire
import CodableAlamofire

protocol NetworkingProvider {
    @discardableResult
    func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T>) -> Void) -> DataRequest
}

enum NetworkingError: LocalizedError {
    case network(Error, response: HTTPURLResponse?)
    
    var errorDescription: String? {
        switch self {
        case .network(let error, _):
            return error.localizedDescription
        }
    }
}

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
                completion(.failure(NetworkingError.network(error, response: dataResponse.response)))
            }
        }
    
        dataRequest.resume()
        return dataRequest
    }
}
