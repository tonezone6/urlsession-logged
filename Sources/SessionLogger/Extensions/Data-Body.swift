//
//  Data-Body.swift
//  HackerNews
//
//  Created by Alex Stratu on 06.02.2021.
//

import Foundation

extension Data {
    
    var body: String? {
        // json encoded.
        if let json = try? JSONSerialization.jsonObject(with: self, options: []),
           let jdata = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]),
           let string = String(data: jdata, encoding: .utf8) {
            return string
        }
        // url encoded.
        if let string = String(data: self, encoding: .utf8) {
            return string
        }
        return nil
    }
}
