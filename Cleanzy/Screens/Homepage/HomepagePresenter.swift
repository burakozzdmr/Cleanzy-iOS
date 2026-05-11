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
}

// MARK: - HomepagePresenterProtocol

extension HomepagePresenter: HomepagePresenterProtocol {
    func viewDidLoad() {
        let greeting = KeychainManager.shared.userName ?? "Kullanıcı"
        view?.displayGreeting(greeting)
        view?.showLoading()
        interactor?.fetchCleaners()
    }
}

// MARK: - HomepageInteractorOutputProtocol

extension HomepagePresenter: HomepageInteractorOutputProtocol {
    func didFetchCleaners(_ cleaners: [CleanerResponseModel]) {
        view?.hideLoading()
        let items = cleaners.map { HomepageCleanerItem(from: $0) }
        view?.displayCleaners(items)
    }

    func didFailFetchingCleaners(with message: String) {
        view?.hideLoading()
        view?.showAlert(with: .init(title: "Hata", message: message))
    }
}
