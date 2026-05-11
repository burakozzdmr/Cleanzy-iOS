//
//  AppointmentConfirmContracts.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - AppointmentConfirmViewProtocol

protocol AppointmentConfirmViewProtocol: BaseViewProtocol, AnyObject {
    var presenter: AppointmentConfirmPresenterProtocol! { get set }
}

// MARK: - AppointmentConfirmInteractorInputProtocol

protocol AppointmentConfirmInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: AppointmentConfirmInteractorOutputProtocol? { get set }
}

// MARK: - AppointmentConfirmInteractorOutputProtocol

protocol AppointmentConfirmInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject { }

// MARK: - AppointmentConfirmPresenterProtocol

protocol AppointmentConfirmPresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: AppointmentConfirmViewProtocol? { get set }
    var interactor: AppointmentConfirmInteractorInputProtocol? { get set }
    var router: AppointmentConfirmRouterProtocol? { get set }

    var confirmItem: AppointmentConfirmItem { get }

    func didTapGoToAppointments()
    func didTapGoHome()
}

// MARK: - AppointmentConfirmRouterProtocol

protocol AppointmentConfirmRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: AppointmentConfirmPresenterProtocol? { get set }

    func navigateToAppointments()
    func navigateToHome()
}

// MARK: - AppointmentConfirmBuilderProtocol

protocol AppointmentConfirmBuilderProtocol: AnyObject {
    static func createModule(with item: AppointmentConfirmItem) -> AppointmentConfirmViewController
}
