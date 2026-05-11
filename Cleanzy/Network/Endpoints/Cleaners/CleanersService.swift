//
//  CleanersService.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Combine
import Foundation

// MARK: - CleanersServiceProtocol

protocol CleanersServiceProtocol {
    func getCleanerList(request: GetCleanerListRequestModel) -> AnyPublisher<CleanerListSuccessResponse, NetworkError>
    func getCleanerByID(request: GetCleanerByIDRequestModel) -> AnyPublisher<CleanerSuccessResponse, NetworkError>
}

// MARK: - CleanersService

final class CleanersService: CleanersServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
}

// MARK: - Methods

extension CleanersService {
    func getCleanerList(request: GetCleanerListRequestModel) -> AnyPublisher<CleanerListSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: CleanerListSuccessResponse.self)
    }

    func getCleanerByID(request: GetCleanerByIDRequestModel) -> AnyPublisher<CleanerSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: CleanerSuccessResponse.self)
    }
}
