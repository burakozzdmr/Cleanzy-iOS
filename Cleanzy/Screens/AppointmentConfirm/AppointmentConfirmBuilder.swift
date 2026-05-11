//
//  AppointmentConfirmBuilder.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import UIKit

// MARK: - AppointmentConfirmBuilder

final class AppointmentConfirmBuilder { }

// MARK: - AppointmentConfirmBuilderProtocol

extension AppointmentConfirmBuilder: AppointmentConfirmBuilderProtocol {
    static func createModule(with item: AppointmentConfirmItem) -> AppointmentConfirmViewController {
        let view = AppointmentConfirmViewController()
        let presenter = AppointmentConfirmPresenter(item: item)
        let interactor = AppointmentConfirmInteractor()
        let router = AppointmentConfirmRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter

        return view
    }
}
