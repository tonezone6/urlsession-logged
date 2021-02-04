//
//  URLSession+Logger.swift
//
//  Created by tonezone6 on 08/06/2020.
//

import Foundation

public extension URLSession {
    
    /// Console output helper.
    /// It provides various logging methods
    /// for request, response, data and error.
    struct Logger {
            
        enum Item: String {
            case requestHeaders = "request headers"
            case requestBody    = "request body"
            case responseCode   = "response code"
            case responseBody   = "response body"
            case responseError  = "response error"
            
            var formatted: String { "+ \(rawValue):" }
        }
        
        struct Icon {
            static let request = "⬆️"
            static let success = "✅"
            static let failure = "⛔️"
        }

        // MARK: Request.

        public static func log(_ request: URLRequest) {
            var output: [String] = []
            
            if let method = request.httpMethod, let url = request.url?.absoluteString {
                output.append("\(Icon.request) \(method) \(url)")
            }
            if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
                output.append("\(Item.requestHeaders.formatted) \(headers)")
            }
            if let data = request.httpBody, let body = json(with: data) {
                output.append("\(Item.requestBody.formatted) \(body)")
            }

            print(output.log)
        }
        
        // MARK: Response.

        public static func log(_ response: URLResponse) {
            guard let urlResponse = response as? HTTPURLResponse,
                  let url = urlResponse.url?.absoluteString
            else { return }
            
            let icon = (200...299)
                .contains(urlResponse.statusCode) ? Icon.success : Icon.failure
            
            var output: [String] = []
            output.append("\(icon) \(url)")
            output.append("\(Item.responseCode.formatted) \(urlResponse.statusCode)")
            
            print(output.log)
        }
        
        // MARK: Data.

        public static func log(_ data: Data) {
            guard let body = json(with: data), !body.isEmpty
            else { return }
            
            var output: [String] = []
            output.append("\(Item.responseBody.formatted)")
            output.append(body)
            
            print(output.log)
        }
        
        // MARK: Error.
        
        public static func log(_ error: Error) {
            guard let error = error as? URLError,
                  let url = error.failureURLString
            else { return }
            
            var output: [String] = []
            output.append("\(Icon.failure) \(url)")
            output.append("\(Item.responseCode.formatted) \(error.errorCode)")
            output.append("\(Item.responseError.formatted) \(error.localizedDescription)")
            
            print(output.log)
        }
    }
}

private extension URLSession.Logger {
    static func json(with data: Data) -> String? {
        guard let object = try? JSONSerialization.jsonObject(with: data, options: []),
              let data   = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let json   = String(data: data, encoding: .utf8)
        else { return nil }
        
        return json
    }
}

private extension Array where Element == String {
    var log: String {
        joined(separator: "\n")
    }
}
