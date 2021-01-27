//
//  URLSession+Resource.swift
//
//  Created by tonezone6 on 08/06/2020.
//

import Foundation

public extension URLSession {
    
    func load<T: Decodable>(
        _ resource: T.Type,
        with request: URLRequest,
        decoder: JSONDecoder = .init(),
        completion: @escaping (Result<T, Error>) -> Void) {
        
        Logger.log(request)
        
        dataTask(with: request) { (data, response, error) in
            if let error = error {
                Logger.log(error)
                return completion(.failure(error))
            } else if let response = response, let data = data {
                Logger.log(response)
                Logger.log(data)
                do {
                    let resource = try decoder.decode(T.self, from: data)
                    completion(.success(resource))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
