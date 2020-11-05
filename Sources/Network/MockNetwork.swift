//
//  MockNetwork.swift
//  Loterias-Da-Sorte-iOS
//
//  Created by Gabriel Soria Souza on 04/10/20.
//  Copyright © 2020 Gabriel Sória Souza. All rights reserved.
//

import Foundation

public final class MockNetwork: NetworkServiceable {
    
    let fileName: String
    
    public init(fileName: String) {
        self.fileName = fileName
    }
    
    public func request(url: String, completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        let file = Bundle.main.url(forResource: self.fileName, withExtension: "json")!
        let data = try! Data(contentsOf: file)
        completion(.success(data))
    }
}
