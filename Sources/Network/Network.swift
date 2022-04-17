//
//  Networkable.swift
//  
//
//  Created by Gabriel Soria Souza on 10/06/21.
//

import Foundation

public protocol Networkable {
    func request(url: String) async throws -> Data
    func request(url: String,
                 completion: @escaping ((Result<Data, NetworkError>) -> Void))
}

public final class Network: Networkable {
    
    private let configuration: URLSessionConfiguration
    private let session: URLSession
    
    public init(urlSession: URLSession? = nil) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20.0
        self.configuration = configuration
        
        if let session = urlSession {
            self.session = session
            return
        }
        self.session = URLSession(configuration: self.configuration)
    }

    
    public func request(url: String) async throws -> Data {
        guard let safeURL = URL(string: url) else {
            throw NetworkError.url
        }
        let request = URLRequest(url: safeURL)
        let (data, response) = try await self.session.data(for: request)
        
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                return data
            }
            throw NetworkError.responseStatusCode(code: response.statusCode)
        }
        throw NetworkError.taskError(error: NSError(domain: "Could not check error",
                                                    code: 12312,
                                                    userInfo: nil))
    }
    
    
    public func request(url: String, completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        guard let safeURL = URL(string: url) else {
            completion(.failure(.url))
            return
        }
        self.session.dataTask(with: safeURL) { data, response, error in
            if let response = response as? HTTPURLResponse,
               response.statusCode == 200,
            let data = data {
                completion(.success(data))
            } else {
                completion(.failure(.noResponse))
            }
            return
        }
    }
}
