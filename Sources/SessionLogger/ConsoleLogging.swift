//
//  URLSession+Logger.swift
//
//  Created by tonezone6 on 08/06/2020.
//

import Foundation

protocol ConsoleLogging {
    
    static func log(_ request: URLRequest)
    func log(_ response: URLResponse, _ data: Data)
    func log(_ error: Error)
}

enum Output: String {
    case requestHeaders = "request headers"
    case requestBody    = "request body"
    case responseCode   = "response code"
    case responseBody   = "response body"
    case responseError  = "response error"
    
    var bulletPrefix: String { "\t* \(rawValue):" }
}

enum Symbol: String {
    case request = "🚀"
    case success = "👍"
    case failure = "⛔️"
}

extension ConsoleLogging {
    
    static var newline: String { "\n" }
    static var tab    : String { "\t" }
    
    static func log(_ request: URLRequest) {
        var output: [String] = []
        
        if let method = request.httpMethod,
           let url = request.url?.absoluteString {
            output.append(Symbol.request.rawValue + tab + method + " " + url)
        }
        if let headers = request.allHTTPHeaderFields,
           !headers.isEmpty {
            output.append(Output.requestHeaders.bulletPrefix + " " + "\(headers)")
        }
        if let data = request.httpBody,
           let body = json(with: data) {
            output.append(Output.requestBody.bulletPrefix + " " + body)
        }
        output.append(newline)

        print(output.log)
    }
    
    func log(_ response: URLResponse, _ data: Data) {
        let success: ClosedRange = (200...299)
        
        guard let urlResponse = response as? HTTPURLResponse,
              let url = urlResponse.url?.absoluteString
        else { return }
        
        let icon = success.contains(urlResponse.statusCode) ?
            Symbol.success.rawValue :
            Symbol.failure.rawValue
        
        var output: [String] = []
        output.append(icon + Self.tab + url)
        output.append(Output.responseCode.bulletPrefix + " " + "\(urlResponse.statusCode)")
        
        if let body = Self.json(with: data),
           !body.isEmpty {
            output.append(Output.responseBody.bulletPrefix + " " + body.tabbed)
        }
        output.append(Self.newline)
        
        print(output.log)
    }
        
    func log(_ error: Error) {
        guard let error = error as? URLError,
              let url = error.failureURLString
        else { return }
        
        var output: [String] = []
        output.append(Symbol.failure.rawValue + Self.tab + url)
        output.append(Output.responseCode.bulletPrefix + " " + "\(error.errorCode)")
        output.append(Output.responseError.bulletPrefix + " " + error.localizedDescription)
        output.append(Self.newline)
        
        print(output.log)
    }
}

extension ConsoleLogging {
    
    static func json(with data: Data) -> String? {
        // JSON encoded.
        if let object = try? JSONSerialization.jsonObject(with: data, options: []),
              let jsonData = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let string = String(data: jsonData, encoding: .utf8) {
            return string
        }
        // URL encoded.
        if let string = String(data: data, encoding: .utf8) {
            return string
        }
        return nil
    }
}

// MARK: Other extensions.

private extension Array where Element == String {
    
    var log: String {
        joined(separator: "\n")
    }
}

private extension String {
    
    var tabbed: String {
        replacingOccurrences(of: "\n", with: "\n\t")
    }
}
