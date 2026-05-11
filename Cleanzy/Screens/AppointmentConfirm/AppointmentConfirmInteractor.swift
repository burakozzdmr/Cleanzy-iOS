//
//  AppointmentConfirmInteractor.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - AppointmentConfirmInteractor

final class AppointmentConfirmInteractor {
    weak var presenter: AppointmentConfirmInteractorOutputProtocol?
}

// MARK: - AppointmentConfirmInteractorInputProtocol

extension AppointmentConfirmInteractor: AppointmentConfirmInteractorInputProtocol { }
