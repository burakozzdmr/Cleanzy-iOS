//
//  ServiceCleanersContracts.swift
//  Cleanzy
//

import Foundation

protocol ServiceCleanersViewProtocol: BaseViewProtocol, AnyObject {
    var presenter: ServiceCleanersPresenterProtocol! { get set }
    func displayCleaners(_ items: [HomepageCleanerItem])
    func showEmptyState()
}

protocol ServiceCleanersInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: ServiceCleanersInteractorOutputProtocol? { get set }
    func fetchCleaners(for service: CleaningService)
}

protocol ServiceCleanersInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject {
    func didFetchCleaners(_ cleaners: [CleanerResponseModel])
    func didFailFetchingCleaners(with message: String)
}

protocol ServiceCleanersPresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: ServiceCleanersViewProtocol? { get set }
    var interactor: ServiceCleanersInteractorInputProtocol? { get set }
    var router: ServiceCleanersRouterProtocol? { get set }
    func didSelectCleaner(at index: Int)
}

protocol ServiceCleanersRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: ServiceCleanersPresenterProtocol? { get set }
    func navigateToDetail(cleanerID: Int)
}

protocol ServiceCleanersBuilderProtocol: AnyObject {
    static func createModule(service: CleaningService) -> ServiceCleanersViewController
}
