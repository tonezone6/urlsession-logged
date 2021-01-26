//
//  URLSession+Publisher.swift
//
//  Created by tonezone6 on 08/06/2020.
//

import Combine
import Foundation

public extension URLSession {
    
    @available(iOS 13.0, *)
    func load<T: Decodable>(
        _ resource: T.Type,
        with request: URLRequest,
        decoder: JSONDecoder = .init()) -> AnyPublisher<T, Error> {
        
        Logger.log(request)
        
        return dataTaskPublisher(for: request)
            .map { output -> URLSession.DataTaskPublisher.Output in
                Logger.log(output.response)
                Logger.log(output.data)
                return output
            }
            .mapError { error -> Error in
                Logger.log(error)
                return error
            }
            .map(\.data)
            .decode(type: resource.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
