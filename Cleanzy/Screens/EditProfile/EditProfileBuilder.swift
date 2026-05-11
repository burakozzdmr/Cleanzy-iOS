//
//  EditProfileBuilder.swift
//  Cleanzy
//

import UIKit

// MARK: - EditProfileBuilder

final class EditProfileBuilder: EditProfileBuilderProtocol {
    static func createModule() -> EditProfileViewController {
        let view       = EditProfileViewController()
        let interactor = EditProfileInteractor()
        let presenter  = EditProfilePresenter()
        let router     = EditProfileRouter()

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
