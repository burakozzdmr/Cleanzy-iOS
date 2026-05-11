//
//  SearchContracts.swift
//  Cleanzy
//

import Foundation

protocol SearchViewProtocol: BaseViewProtocol, AnyObject {
    var presenter: SearchPresenterProtocol! { get set }
    func displayResults(_ items: [HomepageCleanerItem])
    func showEmpty(query: String)
}

protocol SearchInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: SearchInteractorOutputProtocol? { get set }
    func fetchAllCleaners()
}

protocol SearchInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject {
    func didFetchCleaners(_ cleaners: [CleanerResponseModel])
    func didFailFetching(with message: String)
}

protocol SearchPresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: SearchViewProtocol? { get set }
    var interactor: SearchInteractorInputProtocol? { get set }
    var router: SearchRouterProtocol? { get set }

    func didChangeQuery(_ query: String)
    func didSelectResult(at index: Int)
}

protocol SearchRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: SearchPresenterProtocol? { get set }
    func navigateToDetail(cleanerID: Int)
}

protocol SearchBuilderProtocol: AnyObject {
    static func createModule() -> SearchViewController
}
