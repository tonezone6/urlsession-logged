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
    var tb: String { "\t*" }
    
    var value: String {
        switch self {
        case .request(let method, let url):
            return "\n🚀\t\(method) \(url)"
            
        case .headers(let dict):
            return "\(tb) headers: \(dict)"
        
        case .response(let code, let url):
            let success = (200...299).contains(code)
            let emojy = success ? "👍" : "⛔️"
            return """
                \(emojy)\t\(url)
                \(tb) code: \(code)
                """
            
        case .body(let string):
            let body = string.replacingOccurrences(of: "\n", with: "\n\t")
            return "\(tb) body: \(body)"
    
        case .failure(let error):
            return """
                ⛔️\t\(error.failureURLString ?? "")
                \(tb) code: \(error.errorCode)
                \(tb) error: \(error.localizedDescription)
                """
        }
    }
}
