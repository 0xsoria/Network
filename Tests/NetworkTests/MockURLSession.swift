//
//  File.swift
//  
//
//  Created by Gabriel Soria Souza on 09/05/21.
//

import Foundation

final class MockURLSession: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    var calledCancel = false
    var url: URL?
    var queue: DispatchQueue? = nil
    
    func givenDispatchQueue() {
      queue = DispatchQueue(label: "com.MockSession")
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        let task = MockURLSessionDataTask(closure: {
            //completionHandler(data, response, error)
        }, completionHandler: completionHandler, url: url, queue: queue)
        return task
    }

    func cancel() {
        calledCancel = true
    }
}


final class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    var calledCancel = false
    var data: Data?
    var error: Error?
    var response: URLResponse?
    var url: URL?
    var queue: DispatchQueue? = nil
    
    func givenDispatchQueue() {
      queue = DispatchQueue(label: "com.MockSession")
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        let response = self.response
        let task = MockURLSessionDataTask(closure: {
            completionHandler(data, response, error)
        }, completionHandler: completionHandler, url: url, queue: queue)
        return task
    }

    func cancel() {
        calledCancel = true
    }
}
