//
//  HomepageContracts.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 22.11.2025.
//

import Foundation

// MARK: - HomepageViewProtocol

protocol HomepageViewProtocol: BaseViewProtocol, AnyObject {
    var presenter: HomepagePresenterProtocol! { get set }

    func displayCleaners(_ items: [HomepageCleanerItem])
    func displayGreeting(_ name: String)
}

// MARK: - HomepageInteractorInputProtocol

protocol HomepageInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: HomepageInteractorOutputProtocol? { get set }

    func fetchCleaners()
}

// MARK: - HomepageInteractorOutputProtocol

protocol HomepageInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject {
    func didFetchCleaners(_ cleaners: [CleanerResponseModel])
    func didFailFetchingCleaners(with message: String)
}

// MARK: - HomepagePresenterProtocol

protocol HomepagePresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: HomepageViewProtocol? { get set }
    var interactor: HomepageInteractorInputProtocol? { get set }
    var router: HomepageRouterProtocol? { get set }

    func didSelectCleaner(at index: Int)
    func didSelectService(at index: Int)
    func didTapSearch()
}

// MARK: - HomepageRouterProtocol

protocol HomepageRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: HomepagePresenterProtocol? { get set }

    func navigateToDetail(cleanerID: Int)
    func navigateToServiceCleaners(service: CleaningService)
    func navigateToSearch()
}

// MARK: - HomepageBuilderProtocol

protocol HomepageBuilderProtocol: BaseBuilderProtocol, AnyObject { }
