//
//  NetworkService.swift
//  Loterias-Da-Sorte-iOS
//
//  Created by Gabriel Soria Souza on 01/10/20.
//  Copyright © 2020 Gabriel Sória Souza. All rights reserved.
//

import Foundation

public final class NetworkService: NetworkServiceable {
    
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

    public func request(url: String, completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        guard let safeURL = URL(string: url) else {
            completion(.failure(.url))
            return
        }
        
        let dataTask = self.session.dataTask(with: safeURL) { (data, response, error) in
            self.response(completion: completion)(data, response, error)
        }
        dataTask.resume()
    }
    
    private func response(completion: @escaping (Result<Data, NetworkError>) -> Void) -> ((Data?, URLResponse?, Error?) -> Void) {
        return { data, response, error in
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(.noResponse))
                    return
                }
                if response.statusCode == 200 {
                    guard let data = data else {
                        completion(.failure(.noData))
                        return
                    }
                    completion(.success(data))
                    
                } else {
                    completion(.failure(.responseStatusCode(code: response.statusCode)))
                }
            } else {
                completion(.failure(.taskError(error: error!)))
            }
        }
    }
}
