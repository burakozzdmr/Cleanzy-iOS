//
//  FavoritesManager.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.05.2026.
//

import Foundation

// MARK: - FavoritesManager

final class FavoritesManager {

    static let shared = FavoritesManager()
    private init() {}

    private let key = "saved_favorites"

    // MARK: - Public

    func getFavorites() -> [FavoriteItem] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let items = try? JSONDecoder().decode([FavoriteItem].self, from: data) else {
            return []
        }
        return items
    }

    func isFavorite(cleanerID: Int) -> Bool {
        getFavorites().contains { $0.cleanerID == cleanerID }
    }

    @discardableResult
    func toggleFavorite(_ item: FavoriteItem) -> Bool {
        var items = getFavorites()
        if let index = items.firstIndex(where: { $0.cleanerID == item.cleanerID }) {
            items.remove(at: index)
            save(items)
            return false
        } else {
            items.append(item)
            save(items)
            return true
        }
    }

    // MARK: - Private

    private func save(_ items: [FavoriteItem]) {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
