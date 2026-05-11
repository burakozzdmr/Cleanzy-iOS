//
//  UserDetailBuilder.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import UIKit

// MARK: - UserDetailBuilder

final class UserDetailBuilder { }

// MARK: - UserDetailBuilderProtocol

extension UserDetailBuilder: UserDetailBuilderProtocol {
    static func createModule(with cleanerID: Int) -> UserDetailViewController {
        let view = UserDetailViewController()
        let presenter = UserDetailPresenter(cleanerID: cleanerID)
        let interactor = UserDetailInteractor()
        let router = UserDetailRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter

        return view
    }
}
