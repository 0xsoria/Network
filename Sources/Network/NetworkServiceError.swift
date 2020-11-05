//
//  NetworkServiceError.swift
//  Loterias-Da-Sorte-iOS
//
//  Created by Gabriel Soria Souza on 01/10/20.
//  Copyright © 2020 Gabriel Sória Souza. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}
