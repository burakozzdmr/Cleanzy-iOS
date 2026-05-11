//
//  AuthService.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Combine
import Foundation

// MARK: - AuthServiceProtocol

protocol AuthServiceProtocol {
    func login(request: LoginRequestModel) -> AnyPublisher<AuthSuccessResponse, NetworkError>
    func register(request: RegisterRequestModel) -> AnyPublisher<AuthSuccessResponse, NetworkError>
}

// MARK: - AuthService

final class AuthService: AuthServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
}

// MARK: - Methods

extension AuthService {
    func login(request: LoginRequestModel) -> AnyPublisher<AuthSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: AuthSuccessResponse.self)
    }

    func register(request: RegisterRequestModel) -> AnyPublisher<AuthSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: AuthSuccessResponse.self)
    }
}
