//
//  MockNetwork.swift
//  Loterias-Da-Sorte-iOS
//
//  Created by Gabriel Soria Souza on 04/10/20.
//  Copyright © 2020 Gabriel Sória Souza. All rights reserved.
//

import Foundation

public final class MockNetwork: NetworkServiceable, Networkable {
    let fileName: String
    
    public init(fileName: String) {
        self.fileName = fileName
    }
    
    @available(iOS 15.0, macOS 12.0, watchOS 8.0, *)
    public func request(url: String) async throws -> Data {
        if let file = Bundle.module.url(forResource: self.fileName, withExtension: "json") {
            let data = try Data(contentsOf: file)
            return data
        }
        throw NetworkError.noData
    }
    
    public func request(url: String,
                        completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        if let file = Bundle.module.url(forResource: self.fileName,
                                        withExtension: "json"),
           let data = try? Data(contentsOf: file) {
            completion(.success(data))
        } else {
            completion(.failure(.noResponse))
        }
    }
}
