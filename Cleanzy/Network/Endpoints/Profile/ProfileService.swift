//
//  ProfileService.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Combine
import Foundation

// MARK: - ProfileServiceProtocol

protocol ProfileServiceProtocol {
    func getProfile(request: GetProfileRequestModel) -> AnyPublisher<ProfileSuccessResponse, NetworkError>
    func updateProfile(request: UpdateProfileRequestModel) -> AnyPublisher<ProfileSuccessResponse, NetworkError>
}

// MARK: - ProfileService

final class ProfileService: ProfileServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
}

// MARK: - Methods

extension ProfileService {
    func getProfile(request: GetProfileRequestModel) -> AnyPublisher<ProfileSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: ProfileSuccessResponse.self)
    }

    func updateProfile(request: UpdateProfileRequestModel) -> AnyPublisher<ProfileSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: ProfileSuccessResponse.self)
    }
}
