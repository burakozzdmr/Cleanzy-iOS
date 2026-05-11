//
//  AppointmentConfirmRouter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import UIKit

// MARK: - AppointmentConfirmRouter

final class AppointmentConfirmRouter {
    weak var presenter: AppointmentConfirmPresenterProtocol?
}

// MARK: - AppointmentConfirmRouterProtocol

extension AppointmentConfirmRouter: AppointmentConfirmRouterProtocol {
    func navigateToAppointments() {
        guard let viewController = presenter?.view as? UIViewController else { return }
        let appointmentsVC = AppointmentsBuilder.createModule()
        viewController.navigationController?.pushViewController(appointmentsVC, animated: true)
    }

    func navigateToHome() {
        guard let currentView = presenter?.view else { return }
        popToRoot(currentView, animated: true)
    }
}
