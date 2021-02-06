//
//  MockURLProtocol.swift
//  Tazz by eMAGTests
//
//  Created by Alex Stratu on 04.02.2021.
//  Copyright © 2021 HCL Online Advertising S.R.L. All rights reserved.
//

import Foundation

final public class LogURLProtocol: URLProtocol, ConsoleLogging {
        
    private lazy var session: URLSession = {
        URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }()
    
    private var dataTask: URLSessionTask?
    private var receivedData = Data()
    
    // MARK: URL protocol.
    
    public override class func canInit(
        with request: URLRequest) -> Bool { true }

    public override class func canonicalRequest(
        for request: URLRequest) -> URLRequest { request }
    
    public override func startLoading() {
        dataTask = session.dataTask(with: request)
        dataTask?.resume()
        /* Request */ log(request)
    }
    
    public override func stopLoading() {
        dataTask?.cancel()
    }
}

// MARK: URLSession data delegate.

extension LogURLProtocol: URLSessionDataDelegate {

    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        receivedData.append(data)
        client?.urlProtocol(self, didLoad: data)
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            /* Error */ log(error)
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let response = task.response {
                /* Response, data */ log(response, receivedData)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
    }
}
