//
//  FavoritesManager.swift
//  Cleanzy
//

import Combine
import Foundation

// MARK: - FavoritesManager

final class FavoritesManager {

    static let shared = FavoritesManager()
    private init() {}

    private let service: FavoritesServiceProtocol = FavoritesService()

    private(set) var cachedFavorites: [FavoriteItem] = []

    // MARK: - Sync helper

    func isFavorite(cleanerID: Int) -> Bool {
        cachedFavorites.contains { $0.cleanerID == cleanerID }
    }

    // MARK: - Fetch

    func fetchFavorites() -> AnyPublisher<[FavoriteItem], NetworkError> {
        guard let userId = KeychainManager.shared.userId else {
            cachedFavorites = []
            return Just([]).setFailureType(to: NetworkError.self).eraseToAnyPublisher()
        }

        return service
            .getFavoritesByUserID(request: GetFavoritesByUserIDRequestModel(userId: userId))
            .map { [weak self] response -> [FavoriteItem] in
                let items = response.data.map { FavoriteItem(from: $0) }
                self?.cachedFavorites = items
                return items
            }
            .eraseToAnyPublisher()
    }

    // MARK: - Toggle
    // Emits `true` if added, `false` if removed.

    func toggleFavorite(_ item: FavoriteItem) -> AnyPublisher<Bool, NetworkError> {
        guard let currentUserId = KeychainManager.shared.userId else {
            return Fail(error: NetworkError.unauthorized).eraseToAnyPublisher()
        }

        let favoritedUserId = item.favoritedUserId ?? item.cleanerID

        if isFavorite(cleanerID: item.cleanerID) {
            return service
                .removeFavorite(request: RemoveFavoriteRequestModel(userId: currentUserId, favoritedUserId: favoritedUserId))
                .map { [weak self] _ -> Bool in
                    self?.cachedFavorites.removeAll { $0.cleanerID == item.cleanerID }
                    return false
                }
                .eraseToAnyPublisher()
        } else {
            return service
                .addFavorite(request: AddFavoriteRequestModel(userId: currentUserId, favoritedUserId: favoritedUserId))
                .map { [weak self] _ -> Bool in
                    self?.cachedFavorites.append(item)
                    return true
                }
                .eraseToAnyPublisher()
        }
    }
}
