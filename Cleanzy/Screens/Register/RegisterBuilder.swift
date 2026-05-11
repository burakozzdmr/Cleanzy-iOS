//
//  RegisterBuilder.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 8.11.2025.
//

import UIKit

final class RegisterBuilder { }

// MARK: - RegisterBuilderProtocol

extension RegisterBuilder: RegisterBuilderProtocol {
    static func createModule() -> UIViewController {
        let view = RegisterViewController()
        let presenter = RegisterPresenter()
        let interactor = RegisterInteractor()
        let router = RegisterRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        
        return view
    }
}
