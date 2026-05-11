//
//  HomepagePresenter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 22.11.2025.
//

import Foundation

// MARK: - HomepagePresenter

final class HomepagePresenter {
    weak var view: HomepageViewProtocol?
    var interactor: HomepageInteractorInputProtocol?
    var router: HomepageRouterProtocol?

    private var cleaners: [CleanerResponseModel] = []
}

// MARK: - HomepagePresenterProtocol

extension HomepagePresenter: HomepagePresenterProtocol {
    func viewDidLoad() {
        let greeting = KeychainManager.shared.userName ?? "Kullanıcı"
        view?.displayGreeting(greeting)
        view?.showLoading()
        interactor?.fetchCleaners()
    }

    func didSelectCleaner(at index: Int) {
        guard index < cleaners.count,
              let cleanerID = cleaners[index].id else { return }
        router?.navigateToDetail(cleanerID: cleanerID)
    }

    func didSelectService(at index: Int) {
        let services = CleaningService.allCases
        guard index < services.count else { return }
        router?.navigateToServiceCleaners(service: services[index])
    }

    func didTapSearch() {
        router?.navigateToSearch()
    }
}

// MARK: - HomepageInteractorOutputProtocol

extension HomepagePresenter: HomepageInteractorOutputProtocol {
    func didFetchCleaners(_ cleaners: [CleanerResponseModel]) {
        self.cleaners = cleaners
        view?.hideLoading()
        let items = cleaners.map { HomepageCleanerItem(from: $0) }
        view?.displayCleaners(items)
    }

    func didFailFetchingCleaners(with message: String) {
        view?.hideLoading()
        view?.showAlert(with: .init(title: "Hata", message: message))
    }
}
