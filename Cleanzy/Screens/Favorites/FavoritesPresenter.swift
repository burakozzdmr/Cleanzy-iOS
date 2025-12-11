//
//  FavoritesPresenter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.12.2025.
//

import Foundation

// MARK: - FavoritesPresenter

final class FavoritesPresenter {
    var view: FavoritesViewProtocol?
    var interactor: FavoritesInteractorInputProtocol?
    var router: FavoritesRouterProtocol?
}

// MARK: - FavoritesPresenterProtocol

extension FavoritesPresenter: FavoritesPresenterProtocol {
    
}

// MARK: - FavoritesPresenterInteractorOutputProtocol

extension FavoritesPresenter: FavoritesInteractorOutputProtocol {
    
}
