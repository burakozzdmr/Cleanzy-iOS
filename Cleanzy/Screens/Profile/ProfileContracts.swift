//
//  ProfileContracts.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.12.2025.
//

import Foundation

// MARK: - ProfileViewProtocol

protocol ProfileViewProtocol: BaseViewProtocol, AnyObject {
    var presenter: ProfilePresenterProtocol! { get set }
}

// MARK: - ProfileInteractorInputProtocol

protocol ProfileInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: profileInteractorOutputProtocol? { get set }
}

// MARK: - ProfileInteractorOutputProtocol

protocol profileInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject {
    
}

// MARK: - ProfilePresenterProtocol

protocol ProfilePresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: ProfileViewProtocol? { get set }
    var interactor: ProfileInteractorInputProtocol? { get set }
    var router: ProfileRouterProtocol? { get set }
}

// MARK: - ProfileRouterProtocol

protocol ProfileRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
}

// MARK: - ProfileBuilderProtocol

protocol ProfileBuilderProtocol: BaseBuilderProtocol, AnyObject { }
