//
//  ServiceCleanersBuilder.swift
//  Cleanzy
//

import UIKit

final class ServiceCleanersBuilder: ServiceCleanersBuilderProtocol {
    static func createModule(service: CleaningService) -> ServiceCleanersViewController {
        let view       = ServiceCleanersViewController()
        let interactor = ServiceCleanersInteractor()
        let presenter  = ServiceCleanersPresenter(service: service)
        let router     = ServiceCleanersRouter()

        view.presenter       = presenter
        view.service         = service
        presenter.view       = view
        presenter.interactor = interactor
        presenter.router     = router
        interactor.presenter = presenter
        router.viewController = view
        router.presenter     = presenter

        return view
    }
}
