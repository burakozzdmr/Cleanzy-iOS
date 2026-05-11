//
//  FavoritesPresenter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.12.2025.
//

import Foundation

// MARK: - FavoritesPresenter

final class FavoritesPresenter {
    weak var view: FavoritesViewProtocol?
    var interactor: FavoritesInteractorInputProtocol?
    var router: FavoritesRouterProtocol?

    private var items: [FavoriteItem] = []
}

// MARK: - FavoritesPresenterProtocol

extension FavoritesPresenter: FavoritesPresenterProtocol {
    func viewDidLoad() {
        interactor?.fetchFavorites()
    }

    func didSelectItem(at index: Int) {
        guard index < items.count else { return }
        router?.navigateToDetail(cleanerID: items[index].cleanerID)
    }
}

// MARK: - FavoritesInteractorOutputProtocol

extension FavoritesPresenter: FavoritesInteractorOutputProtocol {
    func didFetchFavorites(_ items: [FavoriteItem]) {
        self.items = items
        if items.isEmpty {
            view?.showEmptyState()
        } else {
            view?.displayFavorites(items)
        }
    }
}
