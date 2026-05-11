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
            NetworkLogger.logRequest(urlRequest)

            let decoder = JSONDecoder()

            return session.dataTaskPublisher(for: urlRequest)
                .tryMap { data, response -> Data in
                    NetworkLogger.logResponse(data: data, response: response)

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
                .mapError { [url = urlRequest.url?.absoluteString] error -> NetworkError in
                    let mapped: NetworkError
                    if let networkError = error as? NetworkError {
                        mapped = networkError
                    } else if let decoding = error as? DecodingError {
                        NetworkLogger.logError(decoding, url: url)
                        mapped = .decodeError
                    } else if let urlError = error as? URLError {
                        switch urlError.code {
                        case .notConnectedToInternet, .networkConnectionLost:
                            mapped = .noInternetConnection
                        case .timedOut:
                            mapped = .timeOut
                        default:
                            mapped = .general(urlError)
                        }
                    } else {
                        mapped = .general(error)
                    }
                    NetworkLogger.logError(mapped, url: url)
                    return mapped
                }
                .eraseToAnyPublisher()

        case .failure(let error):
            NetworkLogger.logError(error)
            return Fail(error: NetworkError.general(error))
                .eraseToAnyPublisher()
        }
    }
}
