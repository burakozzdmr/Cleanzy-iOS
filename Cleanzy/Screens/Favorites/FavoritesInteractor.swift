//
//  FavoritesInteractor.swift
//  Cleanzy
//

import Foundation

// MARK: - FavoritesInteractor

final class FavoritesInteractor {
    var presenter: FavoritesInteractorOutputProtocol?
}

// MARK: - FavoritesInteractorInputProtocol

extension FavoritesInteractor: FavoritesInteractorInputProtocol {
    func fetchFavorites() {
        FavoritesManager.shared.fetchFavorites { [weak self] result in
            switch result {
            case .success(let items):
                self?.presenter?.didFetchFavorites(items)
            case .failure(let error):
                self?.presenter?.didFetchFavorites([])
                print("[FavoritesInteractor] fetchFavorites error: \(error)")
            }
        }
    }
}
