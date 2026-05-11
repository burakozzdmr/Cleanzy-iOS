//
//  FavoritesManager.swift
//  Cleanzy
//

import Combine
import Foundation

// MARK: - FavoritesManager
// In-memory cache for synchronous isFavorite checks.
// Actual persistence is handled by FavoritesService (backend).

final class FavoritesManager {

    static let shared = FavoritesManager()
    private init() {}

    private let service: FavoritesServiceProtocol = FavoritesService()
    private var cancellables: Set<AnyCancellable> = .init()

    // In-memory cache (populated from backend on fetch)
    private(set) var cachedFavorites: [FavoriteItem] = []

    // MARK: - Sync helpers (uses cache)

    func isFavorite(cleanerID: Int) -> Bool {
        cachedFavorites.contains { $0.cleanerID == cleanerID }
    }

    // MARK: - Async fetch

    func fetchFavorites(completion: @escaping (Result<[FavoriteItem], Error>) -> Void) {
        guard let userId = KeychainManager.shared.userId else {
            cachedFavorites = []
            completion(.success([]))
            return
        }

        let request = GetFavoritesByUserIDRequestModel(userId: userId)
        service.getFavoritesByUserID(request: request)
            .receive(on: DispatchQueue.main)
            .sink { result in
                if case .failure(let error) = result {
                    completion(.failure(error))
                }
            } receiveValue: { [weak self] response in
                let items = response.data.map { FavoriteItem(from: $0) }
                self?.cachedFavorites = items
                completion(.success(items))
            }
            .store(in: &cancellables)
    }

    // MARK: - Async toggle

    /// Returns true if the item was added to favorites, false if removed.
    func toggleFavorite(_ item: FavoriteItem, completion: @escaping (Bool) -> Void) {
        guard let currentUserId = KeychainManager.shared.userId else { return }
        let favoritedUserId = item.favoritedUserId ?? item.cleanerID

        if isFavorite(cleanerID: item.cleanerID) {
            let request = RemoveFavoriteRequestModel(userId: currentUserId, favoritedUserId: favoritedUserId)
            service.removeFavorite(request: request)
                .receive(on: DispatchQueue.main)
                .sink { _ in } receiveValue: { [weak self] _ in
                    self?.cachedFavorites.removeAll { $0.cleanerID == item.cleanerID }
                    completion(false)
                }
                .store(in: &cancellables)
        } else {
            let request = AddFavoriteRequestModel(userId: currentUserId, favoritedUserId: favoritedUserId)
            service.addFavorite(request: request)
                .receive(on: DispatchQueue.main)
                .sink { _ in } receiveValue: { [weak self, item] _ in
                    self?.cachedFavorites.append(item)
                    completion(true)
                }
                .store(in: &cancellables)
        }
    }
}
