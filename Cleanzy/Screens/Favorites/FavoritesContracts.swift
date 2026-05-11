//
//  FavoritesContracts.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.12.2025.
//

import Foundation

// MARK: - FavoritesViewProtocol

protocol FavoritesViewProtocol: BaseViewProtocol, AnyObject {
    var presenter: FavoritesPresenterProtocol! { get set }

    func displayFavorites(_ items: [FavoriteItem])
    func showEmptyState()
}

// MARK: - FavoritesInteractorInputProtocol

protocol FavoritesInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: FavoritesInteractorOutputProtocol? { get set }

    func fetchFavorites()
}

// MARK: - FavoritesInteractorOutputProtocol

protocol FavoritesInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject {
    func didFetchFavorites(_ items: [FavoriteItem])
}

// MARK: - FavoritesPresenterProtocol

protocol FavoritesPresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: FavoritesViewProtocol? { get set }
    var interactor: FavoritesInteractorInputProtocol? { get set }
    var router: FavoritesRouterProtocol? { get set }

    func didSelectItem(at index: Int)
}

// MARK: - FavoritesRouterProtocol

protocol FavoritesRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: FavoritesPresenterProtocol? { get set }

    func navigateToDetail(cleanerID: Int)
}

// MARK: - FavoritesBuilderProtocol

protocol FavoritesBuilderProtocol: BaseBuilderProtocol, AnyObject { }
