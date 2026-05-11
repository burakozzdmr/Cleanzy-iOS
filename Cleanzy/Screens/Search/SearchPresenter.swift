//
//  SearchPresenter.swift
//  Cleanzy
//

import Foundation

final class SearchPresenter {
    weak var view: SearchViewProtocol?
    var interactor: SearchInteractorInputProtocol?
    var router: SearchRouterProtocol?

    private var allCleaners: [CleanerResponseModel] = []
    private var filteredCleaners: [CleanerResponseModel] = []
    private var currentQuery: String = ""
}

extension SearchPresenter: SearchPresenterProtocol {
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchAllCleaners()
    }

    func didChangeQuery(_ query: String) {
        currentQuery = query.trimmingCharacters(in: .whitespaces)
        applyFilter()
    }

    func didSelectResult(at index: Int) {
        guard index < filteredCleaners.count,
              let id = filteredCleaners[index].id else { return }
        router?.navigateToDetail(cleanerID: id)
    }

    private func applyFilter() {
        if currentQuery.isEmpty {
            filteredCleaners = allCleaners
        } else {
            filteredCleaners = allCleaners.filter {
                ($0.user?.fullName ?? "").localizedCaseInsensitiveContains(currentQuery)
            }
        }

        if filteredCleaners.isEmpty {
            view?.showEmpty(query: currentQuery)
        } else {
            view?.displayResults(filteredCleaners.map { HomepageCleanerItem(from: $0) })
        }
    }
}

extension SearchPresenter: SearchInteractorOutputProtocol {
    func didFetchCleaners(_ cleaners: [CleanerResponseModel]) {
        allCleaners      = cleaners
        filteredCleaners = cleaners
        view?.hideLoading()
        applyFilter()
    }

    func didFailFetching(with message: String) {
        view?.hideLoading()
        view?.showAlert(with: .init(title: "Hata", message: message))
    }
}
