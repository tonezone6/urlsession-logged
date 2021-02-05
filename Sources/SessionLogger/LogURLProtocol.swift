//
//  MockURLProtocol.swift
//  Tazz by eMAGTests
//
//  Created by Alex Stratu on 04.02.2021.
//  Copyright © 2021 HCL Online Advertising S.R.L. All rights reserved.
//

import Foundation

final class LogURLProtocol: URLProtocol, ConsoleLogging {
    
    private var sessionTask: URLSessionTask?
    private lazy var session: URLSession = {
        URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }()
    
    // MARK: URLProtocol.
    
    override class func canInit(with request: URLRequest) -> Bool {
        LogURLProtocol.log(request)
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        sessionTask = session.dataTask(with: request)
        sessionTask?.resume()
    }
    
    override func stopLoading() {
        sessionTask?.cancel()
    }
}

// MARK: URLSession data delegate.

extension LogURLProtocol: URLSessionDataDelegate {

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let response = dataTask.response {
            log(response, data)
        }
        client?.urlProtocol(self, didLoad: data)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            log(error)
            client?.urlProtocol(self, didFailWithError: error)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
}

