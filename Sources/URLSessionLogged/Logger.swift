
import Foundation

public enum LogLevel {
    case basic, detailed
}

struct Logger {
    let level: LogLevel
    
    init(level: LogLevel) {
        self.level = level
    }
    
    func log(_ request: URLRequest) {
        var array: [String] = []
                
        if let method = request.httpMethod,
           let url = request.url?.absoluteString {
            array.append(Output.request(method: method, url: url).value)
        }
        
        if level == .detailed {
            if let dict = request.allHTTPHeaderFields, !dict.isEmpty {
                array.append(Output.headers(dict).value)
            }
            
            if let inputStream = request.httpBodyStream,
               let data = Data(stream: inputStream),
               let string = String(json: data), !string.isEmpty {
                array.append(Output.body(string).value)
            }
        }
        
        print(array.joined(separator: "\n"))
    }
    
    func log(_ response: URLResponse, _ data: Data) {
        guard let urlResponse = response as? HTTPURLResponse,
              let url = urlResponse.url?.absoluteString
        else { return }
        
        var array: [String] = []
        
        array.append(
            Output.response(code: urlResponse.statusCode, url: url).value
        )
        
        if level == .detailed {
            if let string = String(json: data), !string.isEmpty {
                array.append(Output.body(string).value)
            }
        }
        
        print(array.joined(separator: "\n"))
    }
        
    func log(_ error: Error) {
        guard let error = error as? URLError else { return }
        let output: Output = .failure(error)
        
        print(output.value)
    }
}

public enum Output {
    case request(method: String, url: String)
    case response(code: Int, url: String)
    case headers([String : String])
    case body(String)
    case failure(URLError)
    
    var value: String {
        switch self {
        case .request(let method, let url):
            return "\n" + "🚀" + "\(method) ".tabbed + url
            
        case .headers(let dict):
            var lines: [String] = []
            for (key, value) in dict {
                lines.append("\(key) : \(value)".tabbed)
            }
            return lines.joined(separator: "\n")
            
        case .response(let code, let url):
            return ((200...299).contains(code) ? "✅" : "⛔️") + "\(code) ".tabbed + url

        case .body(let body):
            return body.replacingOccurrences(of: "\n", with: "\n\t").tabbed
            
        case .failure(let error):
            var lines: [String] = []
            lines.append("⛔️" + (error.failureURLString ?? "").tabbed)
            lines.append("\(error.errorCode)".tabbed + " \(error.localizedDescription)")
            return lines.joined(separator: "\n")
        }
    }
}
