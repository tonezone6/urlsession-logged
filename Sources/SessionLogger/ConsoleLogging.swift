//
//  URLSession+Logger.swift
//
//  Created by tonezone6 on 08/06/2020.
//

import Foundation

protocol ConsoleLogging {
    
    func log(_ request: URLRequest)
    func log(_ response: URLResponse, _ data: Data)
    func log(_ error: Error)
}

private extension Array where Element == String {
    mutating func append(_ output: ConsoleOutput) {
        append(output.value)
    }
}

extension ConsoleLogging {

    func log(_ request: URLRequest) {
        var array: [String] = []
                
        if let method = request.httpMethod,
           let url = request.url?.absoluteString {
            array.append(.request(method: method, url: url))
        }
        if let dict = request.allHTTPHeaderFields, !dict.isEmpty {
            array.append(.headers(dict))
        }
        if let inputStream = request.httpBodyStream,
           let data = Data(stream: inputStream),
           let string = String(json: data), !string.isEmpty {
            array.append(.body(string))
        }
        print(array.joined(separator: "\n"))
    }
    
    func log(_ response: URLResponse, _ data: Data) {
        guard let urlResponse = response as? HTTPURLResponse,
              let url = urlResponse.url?.absoluteString
        else { return }
        
        var array: [String] = []
        
        array.append(.response(code: urlResponse.statusCode, url: url))
        if let string = String(json: data), !string.isEmpty {
            array.append(.body(string))
        }
        print(array.joined(separator: "\n"))
    }
        
    func log(_ error: Error) {
        guard let error = error as? URLError else { return }
        
        let output: ConsoleOutput = .failure(error)
        print(output.value)
    }
}
