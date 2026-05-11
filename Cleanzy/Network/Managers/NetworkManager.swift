//
//  NetworkManager.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Combine
import Foundation

// MARK: - NetworkManagerProtocol

protocol NetworkManagerProtocol {
    func executeRequest<T: Codable>(
        with request: BaseRequest,
        as: T.Type
    ) -> AnyPublisher<T, NetworkError>
}

// MARK: - NetworkManager

final class NetworkManager {
    private let session: URLSession
    
    init(session: URLSession = .init(configuration: .default)) {
        self.session = session
    }
}

// MARK: - Methods

extension NetworkManager: NetworkManagerProtocol {
    func executeRequest<T: Codable>(
        with request: any BaseRequest,
        as: T.Type
    ) -> AnyPublisher<T, NetworkError> {
        switch request.buildURLRequest() {
        case .success(let urlRequest):
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            return session.dataTaskPublisher(for: urlRequest)
                .tryMap { data, response -> Data in
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw NetworkError.invalidResponse
                    }

                    guard (200...299).contains(httpResponse.statusCode) else {
                        throw NetworkError.from(statusCode: httpResponse.statusCode)
                    }

                    guard !data.isEmpty else {
                        throw NetworkError.emptyData
                    }

                    return data
                }
                .decode(type: T.self, decoder: decoder)
                .mapError { error -> NetworkError in
                    if let networkError = error as? NetworkError {
                        return networkError
                    } else if error is DecodingError {
                        return .decodeError
                    } else if let urlError = error as? URLError {
                        switch urlError.code {
                        case .notConnectedToInternet, .networkConnectionLost:
                            return .noInternetConnection
                        case .timedOut:
                            return .timeOut
                        default:
                            return .general(error)
                        }
                    } else {
                        return .general(error)
                    }
                }
                .eraseToAnyPublisher()

        case .failure(let error):
            return Fail(error: NetworkError.general(error))
                .eraseToAnyPublisher()
        }
    }
}
