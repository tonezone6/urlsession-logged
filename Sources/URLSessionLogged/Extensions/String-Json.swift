
import Foundation

extension String {
    init?(json: Data) {
        do {
            /// json encoded
            let object = try JSONSerialization.jsonObject(with: json, options: [])
            let data = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted])
            self.init(data: data, encoding: .utf8)
        } catch {
            /// url encoded
            print("decoding json error", error)
            self.init(data: json, encoding: .utf8)
        }
    }
}
