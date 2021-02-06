//
//  InputStream+Body.swift
//  HackerNews
//
//  Created by Alex Stratu on 06.02.2021.
//

import Foundation

extension InputStream {
    
    var data: Data? {
        open()
        
        let bufferSize: Int = 16
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        var data = Data()
        
        while hasBytesAvailable {
            let readB = read(buffer, maxLength: bufferSize)
            data.append(buffer, count: readB)
        }
        
        buffer.deallocate()
        close()
        
        return data
    }
}
