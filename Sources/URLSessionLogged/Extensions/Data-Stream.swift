
import Foundation

extension Data {
    init?(stream: InputStream) {
        self.init()
        
        stream.open()
        
        let bufferSize: Int = 8
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        
        while stream.hasBytesAvailable {
            let readB = stream.read(buffer, maxLength: bufferSize)
            if let error = stream.streamError {
                print("input stream error", error)
                return nil
            }
            append(buffer, count: readB)
        }
        
        buffer.deallocate()
        stream.close()
    }
}
