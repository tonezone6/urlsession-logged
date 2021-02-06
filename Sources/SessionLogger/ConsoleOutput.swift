//
//  Output.swift
//  HackerNews
//
//  Created by Alex Stratu on 06.02.2021.
//

import Foundation

enum ConsoleOutput {
    case request(method: String, url: String)
    case response(code: Int, url: String)
    case headers([String : String])
    case body(String)
    case failure(URLError)
}

extension ConsoleOutput {
    
    var value: String {
        switch self {
        case .request(let method, let url):
            return "\n" + "🚀" + "\t" + method + " " + url
            
        case .headers(let dict):
            return "\t" + "* headers: " + "\(dict)"
        
        case .response(let code, let url):
            let success = (200...299).contains(code)
            let line1 = (success ? "👍" : "⛔️") + "\t" + url
            let line2 = "\t" + "* code: " + "\(code)"
            return [line1, line2].joined(separator: "\n")

        case .body(let string):
            let body = string.replacingOccurrences(of: "\n", with: "\n\t")
            return "\t" +  "* body: " + body
    
        case .failure(let error):
            let line1 = "⛔️" + "\t" + (error.failureURLString ?? "")
            let line2 = "\t" + "* code: " + "\(error.errorCode)"
            let line3 = "\t" + "* error: " + error.localizedDescription
            return [line1, line2, line3].joined(separator: "\n")
        }
    }
}
