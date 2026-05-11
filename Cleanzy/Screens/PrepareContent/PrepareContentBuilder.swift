//
//  PrepareContentBuilder.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 13.11.2025.
//

import UIKit

// MARK: - PrepareContentBuilder

final class PrepareContentBuilder { }

// MARK: - PrepareContentBuilderProtocol

extension PrepareContentBuilder: PrepareContentBuilderProtocol {
    static func createModule() -> UIViewController {
        let view = PrepareContentViewController()
        let presenter = PrepareContentPresenter()
        let interactor = PrepareContentInteractor()
        let router = PrepareContentRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        
        return view
    }
}
