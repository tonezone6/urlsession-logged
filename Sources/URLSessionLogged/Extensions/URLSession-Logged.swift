
import Foundation

extension URLSession {
    public static func logged(_ level: LogLevel = .detailed) -> URLSession {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [URLLogProtocol.self]
        URLLogProtocol.level = level
            
        return URLSession(configuration: config)
    }
}
