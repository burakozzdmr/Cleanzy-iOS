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
}

// MARK: - HomepageInteractorInputProtocol

protocol HomepageInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: HomepageInteractorOutputProtocol? { get set }
}

// MARK: - HomepageInteractorOutputProtocol

protocol HomepageInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject {
    
}

// MARK: - HomepagePresenterProtocol

protocol HomepagePresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: HomepageViewProtocol? { get set }
    var interactor: HomepageInteractorInputProtocol? { get set }
    var router: HomepageRouterProtocol? { get set }
}

// MARK: - HomepageRouterProtocol

protocol HomepageRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: HomepagePresenterProtocol? { get set }
}

// MARK: - HomepageBuilderProtocol

protocol HomepageBuilderProtocol: BaseBuilderProtocol, AnyObject {
    
}
