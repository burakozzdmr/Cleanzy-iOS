//
//  AppointmentConfirmPresenter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - AppointmentConfirmPresenter

final class AppointmentConfirmPresenter {
    weak var view: AppointmentConfirmViewProtocol?
    var interactor: AppointmentConfirmInteractorInputProtocol?
    var router: AppointmentConfirmRouterProtocol?

    let confirmItem: AppointmentConfirmItem

    init(item: AppointmentConfirmItem) {
        self.confirmItem = item
    }
}

// MARK: - AppointmentConfirmPresenterProtocol

extension AppointmentConfirmPresenter: AppointmentConfirmPresenterProtocol {
    func didTapGoToAppointments() {
        router?.navigateToAppointments()
    }

    func didTapGoHome() {
        router?.navigateToHome()
    }
}

// MARK: - AppointmentConfirmInteractorOutputProtocol

extension AppointmentConfirmPresenter: AppointmentConfirmInteractorOutputProtocol { }
