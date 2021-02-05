//
//  URLSession+Logger.swift
//
//  Created by tonezone6 on 08/06/2020.
//

import Foundation

protocol ConsoleLogging {
    
    static func log(_ request: URLRequest)
    func log(_ response: URLResponse)
    func log(_ data: Data)
    func log(_ error: Error)
}

enum Output: String {
    case requestHeaders = "request headers"
    case requestBody    = "request body"
    case responseCode   = "response code"
    case responseBody   = "response body"
    case responseError  = "response error"
    
    var bulletPrefix: String { "+ \(rawValue):" }
}

enum Symbol: String {
    case request = "🚀"
    case success = "👍"
    case failure = "⛔️"
}

extension ConsoleLogging {
    
    static func log(_ request: URLRequest) {
        var output: [String] = []
        
        output.append("\n")
        if let method = request.httpMethod, let url = request.url?.absoluteString {
            output.append("\(Symbol.request.rawValue) \(method) \(url)")
        }
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            output.append("\(Output.requestHeaders.bulletPrefix) \(headers)")
        }
        if let data = request.httpBody, let body = json(with: data) {
            output.append("\(Output.requestBody.bulletPrefix) \(body)")
        }

        print(output.log)
    }
    
    func log(_ response: URLResponse) {
        guard let urlResponse = response as? HTTPURLResponse,
              let url = urlResponse.url?.absoluteString
        else { return }
        
        let icon = (200...299)
            .contains(urlResponse.statusCode) ? Symbol.success.rawValue : Symbol.failure.rawValue
        
        var output: [String] = []
        output.append("\n")
        output.append("\(icon) \(url)")
        output.append("\(Output.responseCode.bulletPrefix) \(urlResponse.statusCode)")
        
        print(output.log)
    }
    
    func log(_ data: Data) {
        guard let body = Self.json(with: data), !body.isEmpty
        else { return }
        
        var output: [String] = []
        output.append("\(Output.responseBody.bulletPrefix)")
        output.append(body)
        
        print(output.log)
    }
        
    func log(_ error: Error) {
        guard let error = error as? URLError,
              let url = error.failureURLString
        else { return }
        
        var output: [String] = []
        output.append("\n")
        output.append("\(Symbol.failure.rawValue) \(url)")
        output.append("\(Output.responseCode.bulletPrefix) \(error.errorCode)")
        output.append("\(Output.responseError.bulletPrefix) \(error.localizedDescription)")
        
        print(output.log)
    }
}

extension ConsoleLogging {
    
    static func json(with data: Data) -> String? {
        guard let object = try? JSONSerialization.jsonObject(with: data, options: []),
              let data   = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let json   = String(data: data, encoding: .utf8)
        else { return nil }
        
        return json
    }
}

extension Array where Element == String {
    var log: String {
        joined(separator: "\n")
    }
}
