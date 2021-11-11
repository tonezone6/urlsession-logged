
import Foundation

final public class URLLogProtocol: URLProtocol {
    static var level: LogLevel = .detailed
    
    private let session = URLSession.shared
    private var dataTask: URLSessionTask?
        
    public override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    public override func startLoading() {
        Logger(level: URLLogProtocol.level).log(request)
        
        dataTask = session.dataTask(
            with: request,
            completionHandler: handle(data:response:error:)
        )
        dataTask?.resume()
    }
    
    public override func stopLoading() {
        dataTask?.cancel()
    }
    
    private func handle(data: Data?, response: URLResponse?, error: Error?) {
        if let data = data, let response = response {
            Logger(level: URLLogProtocol.level).log(response, data)
            
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
        } else if let error = error {
            Logger(level: URLLogProtocol.level).log(error)
            
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
}
