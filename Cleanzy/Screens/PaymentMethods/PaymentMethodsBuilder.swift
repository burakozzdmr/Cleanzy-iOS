//
//  PaymentMethodsBuilder.swift
//  Cleanzy
//

import UIKit

// MARK: - PaymentMethodsBuilder

final class PaymentMethodsBuilder: PaymentMethodsBuilderProtocol {
    static func createModule() -> PaymentMethodsViewController {
        let view       = PaymentMethodsViewController()
        let interactor = PaymentMethodsInteractor()
        let presenter  = PaymentMethodsPresenter()
        let router     = PaymentMethodsRouter()

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
