//
//  NetworkModel.swift
//  API_Integration
//
//  Created by Kalyan Chakravarthy Narne on 6/26/23.
//

import Foundation
import Combine

struct NetworkModel {
    
    func makeRequest<T: Codable>(at url: URL) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw NSError(domain: NSURLErrorDomain, code: NSURLErrorBadServerResponse, userInfo: nil)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
