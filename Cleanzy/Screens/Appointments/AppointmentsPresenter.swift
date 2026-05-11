//
//  AppointmentsPresenter.swift
//  Cleanzy
//

import Foundation

// MARK: - AppointmentsPresenter

final class AppointmentsPresenter {
    weak var view: AppointmentsViewProtocol?
    var interactor: AppointmentsInteractorInputProtocol?
    var router: AppointmentsRouterProtocol?
}

// MARK: - AppointmentsPresenterProtocol

extension AppointmentsPresenter: AppointmentsPresenterProtocol {
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchMyAppointments()
    }
}

// MARK: - AppointmentsInteractorOutputProtocol

extension AppointmentsPresenter: AppointmentsInteractorOutputProtocol {
    func didFetchAppointments(_ items: [AppointmentItem]) {
        view?.hideLoading()
        if items.isEmpty {
            view?.showEmptyState()
        } else {
            view?.hideEmptyState()
            view?.displayAppointments(items)
        }
    }

    func didFailFetchingAppointments(with message: String) {
        view?.hideLoading()
        view?.showAlert(with: .init(title: "Hata", message: message))
        view?.showEmptyState()
    }
}
