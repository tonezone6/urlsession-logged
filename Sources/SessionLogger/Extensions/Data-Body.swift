//
//  Data-Body.swift
//  HackerNews
//
//  Created by Alex Stratu on 06.02.2021.
//

import Foundation

extension String {
    
    init?(json: Data) {
        do {
            // JSON encoded.
            let object = try JSONSerialization.jsonObject(with: json, options: [])
            let data = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted])
            self.init(data: data, encoding: .utf8)
        } catch {
            print("-> session logger, decoding JSON error", error)
            
            // URL encoded.
            self.init(data: json, encoding: .utf8)
        }
    }
}

extension Data {
    
    init?(stream: InputStream) {
        self.init()
        stream.open()
        
        let bufferSize: Int = 8
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        
        while stream.hasBytesAvailable {
            let readB = stream.read(buffer, maxLength: bufferSize)
            if let error = stream.streamError {
                print("-> session logger, input stream error", error)
                return nil
            }
            append(buffer, count: readB)
        }
        
        buffer.deallocate()
        stream.close()
    }
}
