//
//  AppointmentsBuilder.swift
//  Cleanzy
//

import UIKit

// MARK: - AppointmentsBuilder

final class AppointmentsBuilder: BaseBuilderProtocol {
    static func createModule() -> UIViewController {
        let view       = AppointmentsViewController()
        let interactor = AppointmentsInteractor()
        let presenter  = AppointmentsPresenter()
        let router     = AppointmentsRouter()

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
