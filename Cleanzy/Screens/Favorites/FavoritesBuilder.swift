//
//  FavoritesBuilder.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.12.2025.
//

import UIKit

// MARK: - FavoritesBuilder

final class FavoritesBuilder { }

// MARK: - FavoritesBuilderProtocol

extension FavoritesBuilder: FavoritesBuilderProtocol {
    static func createModule() -> UIViewController {
        let view = FavoritesViewController()
        let interactor = FavoritesInteractor()
        let presenter = FavoritesPresenter()
        let router = FavoritesRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        
        return view
    }
}
