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
        guard let currentView = presenter?.view else { return }
        popToRoot(currentView, animated: true)
    }

    func navigateToHome() {
        guard let currentView = presenter?.view else { return }
        popToRoot(currentView, animated: true)
    }
}
