//
//  URLSession+Resource.swift
//
//  Created by tonezone6 on 08/06/2020.
//

import Foundation

public extension URLSessionConfiguration {
    
    static var logConfiguration: URLSessionConfiguration {
        let config: URLSessionConfiguration = .default
        config.protocolClasses = [LogURLProtocol.self]
        return config
    }
}

public extension URLSession {
    
    static var logSession: URLSession {
        URLSession(configuration: .logConfiguration)
    }
}
