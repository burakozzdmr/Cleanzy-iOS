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
}

// MARK: - FavoritesInteractorInputProtocol

protocol FavoritesInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: FavoritesInteractorOutputProtocol? { get set }
}

// MARK: - FavoritesInteractorOutputProtocol

protocol FavoritesInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject {
    
}

// MARK: - FavoritesPresenterProtocol

protocol FavoritesPresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: FavoritesViewProtocol? { get set }
    var interactor: FavoritesInteractorInputProtocol? { get set }
    var router: FavoritesRouterProtocol? { get set }
}

// MARK: - FavoritesRouterProtocol

protocol FavoritesRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: FavoritesPresenterProtocol? { get set }
}

// MARK: - FavoritesBuilderProtocol

protocol FavoritesBuilderProtocol: BaseBuilderProtocol, AnyObject { }
