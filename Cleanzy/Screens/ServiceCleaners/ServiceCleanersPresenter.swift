//
//  ServiceCleanersPresenter.swift
//  Cleanzy
//

import Foundation

final class ServiceCleanersPresenter {
    weak var view: ServiceCleanersViewProtocol?
    var interactor: ServiceCleanersInteractorInputProtocol?
    var router: ServiceCleanersRouterProtocol?

    private let service: CleaningService
    private var cleaners: [CleanerResponseModel] = []

    init(service: CleaningService) {
        self.service = service
    }
}

extension ServiceCleanersPresenter: ServiceCleanersPresenterProtocol {
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchCleaners(for: service)
    }

    func didSelectCleaner(at index: Int) {
        guard index < cleaners.count, let id = cleaners[index].id else { return }
        router?.navigateToDetail(cleanerID: id)
    }
}

extension ServiceCleanersPresenter: ServiceCleanersInteractorOutputProtocol {
    func didFetchCleaners(_ cleaners: [CleanerResponseModel]) {
        self.cleaners = cleaners
        view?.hideLoading()
        if cleaners.isEmpty {
            view?.showEmptyState()
        } else {
            view?.displayCleaners(cleaners.map { HomepageCleanerItem(from: $0) })
        }
    }

    func didFailFetchingCleaners(with message: String) {
        view?.hideLoading()
        view?.showAlert(with: .init(title: "Hata", message: message))
        view?.showEmptyState()
    }
}
