//
//  Network.swift
//  CovidCLI
//
//  Created by Mikael Konradsson on 2020-04-13.
//  Copyright © 2020 Mikael Konradsson. All rights reserved.
//

import Foundation

extension String: Error {}

enum Country {
    case code(String)
    case world
}

struct Endpoint {
    static let history = URL(string: "https://covidapi.info/api/v1/country/")!
    static let historyWorld = URL(string: "https://covidapi.info/api/v1/global/count")!
}

enum RequestType {
    case history(country: Country)
}

struct RequestMaker {

    static func makeRequest(type: RequestType) -> URLRequest {
        switch type {
        case let .history(country: .code(code)):
            let url = Endpoint.history.appendingPathComponent(code)
            return URLRequest(url: url)

        case .history(country: .world):
            let url = Endpoint.historyWorld
            return URLRequest(url: url)
        }
    }
}

class Network {

    public func run<T: Decodable>(type: RequestType, completion: @escaping (Result<T, Error>) -> Void) {

        let session = URLSession(configuration: .default)

        let task = session.dataTask(
        with: RequestMaker.makeRequest(type: type)) { (data, response, error) in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure("No data in response"))
                return
            }

            do {
                let decode = JSONDecoder()
                let result = try decode.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
