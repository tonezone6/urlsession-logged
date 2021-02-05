//
//  URLSession+Resource.swift
//
//  Created by tonezone6 on 08/06/2020.
//

import Foundation

public extension URLSession {
    
    static var log: URLSession {
        let configuration: URLSessionConfiguration = .default
        configuration.protocolClasses = [LogURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}
