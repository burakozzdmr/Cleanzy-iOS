//
//  BaseRequest+Default.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

extension BaseRequest {
    var baseURL: String { NetworkConstants.basePath }

    var headers: [String: String] {
        var result = [NetworkConstants.Headers.contentType: NetworkConstants.HeaderValues.json]
        if let token = KeychainManager.shared.accessToken {
            result[NetworkConstants.Headers.authorization] = NetworkConstants.HeaderValues.bearer + token
        }
        return result
    }

    var body: Data? { nil }

    func buildURLRequest() -> Result<URLRequest, NetworkError> {
        guard let url = URL(string: baseURL + path) else {
            return .failure(.invalidURL)
        }
        var urlRequest = URLRequest(url: url, timeoutInterval: NetworkConstants.timeout)
        urlRequest.httpMethod = method.rawValue
        headers.forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }
        urlRequest.httpBody = body
        return .success(urlRequest)
    }
}
