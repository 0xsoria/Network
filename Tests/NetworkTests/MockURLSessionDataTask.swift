//
//  File.swift
//  
//
//  Created by Gabriel Soria Souza on 09/05/21.
//

import Foundation

final class MockURLSessionDataTask: URLSessionDataTask {
    private let closure: () -> Void
    var url: URL?
    var calledResume = false
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)
    
    init(closure: @escaping () -> Void,
         completionHandler:
         @escaping (Data?, URLResponse?, Error?) -> Void,
         url: URL,
         queue: DispatchQueue?) {
        if let queue = queue {
            self.completionHandler = { data, response, error in
                queue.async() {
                    completionHandler(data, response, error)
                }
            }
        } else {
            self.completionHandler = completionHandler
        }
        self.url = url
        self.closure = closure
        super.init()
    }
    
    override func resume() {
        calledResume = true
        closure()
    }
    
    var calledCancel = false
    override func cancel() {
        self.calledCancel = true
    }
}
