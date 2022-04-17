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

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (url, url):
            return true
        case (noResponse, noResponse):
            return true
        case (noData, noData):
            return true
        case (invalidJSON, invalidJSON):
            return true
        case (taskError, taskError):
            return true
        case (let .responseStatusCode(errorData), let .responseStatusCode(secondError)):
            return errorData == secondError
        default:
            return false
        }
    }
}
