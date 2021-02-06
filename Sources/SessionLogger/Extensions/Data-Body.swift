//
//  Data-Body.swift
//  HackerNews
//
//  Created by Alex Stratu on 06.02.2021.
//

import Foundation

extension Data {
    
    var body: String? {
        do {
            // JSON encoded.
            let object = try JSONSerialization.jsonObject(with: self, options: [])
            let data = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted])
            if let string = String(data: data, encoding: .utf8) {
                return string
            }
        } catch {
            print(">>> decoding JSON `body` error", error)
        }
        // URL encoded.
        if let string = String(data: self, encoding: .utf8) {
            return string
        }
        return nil
    }
}
