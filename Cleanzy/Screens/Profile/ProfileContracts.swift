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

    func displayUserInfo(name: String, memberType: String)
    func showLogoutConfirmation()
}

// MARK: - ProfileInteractorInputProtocol

protocol ProfileInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: ProfileInteractorOutputProtocol? { get set }

    func fetchUserInfo()
    func logout()
}

// MARK: - ProfileInteractorOutputProtocol

protocol ProfileInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject {
    func didFetchUserInfo(name: String, memberType: String)
    func didFailFetchingUserInfo(with message: String)
    func didLogoutSuccess()
}

// MARK: - ProfilePresenterProtocol

protocol ProfilePresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: ProfileViewProtocol? { get set }
    var interactor: ProfileInteractorInputProtocol? { get set }
    var router: ProfileRouterProtocol? { get set }

    func didTapRow(_ row: ProfileRow)
    func didConfirmLogout()
}

// MARK: - ProfileRouterProtocol

protocol ProfileRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }

    func navigateToLogin()
    func navigateToEditProfile()
    func navigateToPaymentMethods()
}

// MARK: - ProfileBuilderProtocol

protocol ProfileBuilderProtocol: BaseBuilderProtocol, AnyObject { }
