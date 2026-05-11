//
//  FavoritesService.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Combine
import Foundation

// MARK: - FavoritesServiceProtocol

protocol FavoritesServiceProtocol {
    func addFavorite(request: AddFavoriteRequestModel) -> AnyPublisher<FavoriteSuccessResponse, NetworkError>
    func removeFavorite(request: RemoveFavoriteRequestModel) -> AnyPublisher<FavoriteDeleteSuccessResponse, NetworkError>
    func getFavoritesByUserID(request: GetFavoritesByUserIDRequestModel) -> AnyPublisher<FavoriteListSuccessResponse, NetworkError>
}

// MARK: - FavoritesService

final class FavoritesService: FavoritesServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
}

// MARK: - Methods

extension FavoritesService {
    func addFavorite(request: AddFavoriteRequestModel) -> AnyPublisher<FavoriteSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: FavoriteSuccessResponse.self)
    }

    func removeFavorite(request: RemoveFavoriteRequestModel) -> AnyPublisher<FavoriteDeleteSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: FavoriteDeleteSuccessResponse.self)
    }

    func getFavoritesByUserID(request: GetFavoritesByUserIDRequestModel) -> AnyPublisher<FavoriteListSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: FavoriteListSuccessResponse.self)
    }
}
