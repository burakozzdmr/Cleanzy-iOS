//
//  ProfileBuilder.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.12.2025.
//

import UIKit

// MARK: - ProfileBuilder

final class ProfileBuilder { }

// MARK: - ProfileBuilderProtocol

extension ProfileBuilder: ProfileBuilderProtocol {
    static func createModule() -> UIViewController {
        let view = ProfileViewController()
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter()
        let router = ProfileRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = view

        return view
    }
}
