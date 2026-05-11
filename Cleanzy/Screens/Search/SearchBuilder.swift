//
//  SearchBuilder.swift
//  Cleanzy
//

import UIKit

final class SearchBuilder: SearchBuilderProtocol {
    static func createModule() -> SearchViewController {
        let view       = SearchViewController()
        let interactor = SearchInteractor()
        let presenter  = SearchPresenter()
        let router     = SearchRouter()

        view.presenter       = presenter
        presenter.view       = view
        presenter.interactor = interactor
        presenter.router     = router
        interactor.presenter = presenter
        router.viewController = view
        router.presenter     = presenter

        return view
    }
}
