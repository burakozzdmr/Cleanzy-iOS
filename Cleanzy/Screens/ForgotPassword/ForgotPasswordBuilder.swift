//
//  ForgotPasswordBuilder.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 13.11.2025.
//

import UIKit

final class ForgotPasswordBuilder { }

// MARK: - ForgotPasswordBuilderProtocol

extension ForgotPasswordBuilder: ForgotPasswordBuilderProtocol {
    static func createModule() -> UIViewController {
        let viewController = ForgotPasswordViewController()
        let interactor = ForgotPasswordInteractor()
        let presenter = ForgotPasswordPresenter()
        let router = ForgotPasswordRouter()
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.view = viewController
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        
        return viewController
    }
}
