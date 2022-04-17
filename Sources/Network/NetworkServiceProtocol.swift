//
//  NetworkServiceProtocol.swift
//  Loterias-Da-Sorte-iOS
//
//  Created by Gabriel Soria Souza on 01/10/20.
//  Copyright © 2020 Gabriel Sória Souza. All rights reserved.
//

import Foundation

public protocol NetworkServiceable {
    func request(url: String, completion: @escaping ((Result<Data, NetworkError>) -> Void))
}
