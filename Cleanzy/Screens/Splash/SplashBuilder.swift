//
//  SplashBuilder.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 7.11.2025.
//

import UIKit

final class SplashBuilder { }

// MARK: - SplashBuilderProtocol

extension SplashBuilder: SplashBuilderProtocol {
    static func createModule() -> UIViewController {
        let view = SplashViewController()
        let presenter = SplashPresenter()
        let interactor = SplashInteractor()
        let router = SplashRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        
        return view
    }
}
