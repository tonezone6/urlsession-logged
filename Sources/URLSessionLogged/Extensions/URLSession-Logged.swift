
import Foundation

extension URLSession {
    public static func logged(
        _ level: LogLevel = .detailed,
        configuration: URLSessionConfiguration = .default) -> Self {
            
        configuration.protocolClasses = [URLLogProtocol.self]
        URLLogProtocol.level = level
        return .init(configuration: configuration)
    }
}
