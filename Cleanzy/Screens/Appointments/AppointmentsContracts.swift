//
//  AppointmentsContracts.swift
//  Cleanzy
//

import Foundation

// MARK: - AppointmentsViewProtocol

protocol AppointmentsViewProtocol: BaseViewProtocol, AnyObject {
    var presenter: AppointmentsPresenterProtocol! { get set }

    func displayAppointments(_ items: [AppointmentItem])
    func showEmptyState()
    func hideEmptyState()
}

// MARK: - AppointmentsInteractorInputProtocol

protocol AppointmentsInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: AppointmentsInteractorOutputProtocol? { get set }

    func fetchMyAppointments()
}

// MARK: - AppointmentsInteractorOutputProtocol

protocol AppointmentsInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject {
    func didFetchAppointments(_ items: [AppointmentItem])
    func didFailFetchingAppointments(with message: String)
}

// MARK: - AppointmentsPresenterProtocol

protocol AppointmentsPresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: AppointmentsViewProtocol? { get set }
    var interactor: AppointmentsInteractorInputProtocol? { get set }
    var router: AppointmentsRouterProtocol? { get set }
}

// MARK: - AppointmentsRouterProtocol

protocol AppointmentsRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: AppointmentsPresenterProtocol? { get set }
}

// MARK: - AppointmentsBuilderProtocol

protocol AppointmentsBuilderProtocol: BaseBuilderProtocol, AnyObject { }
