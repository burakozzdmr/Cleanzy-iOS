//
//  SplashContracts.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 8.11.2025.
//

import UIKit

// MARK: - SplashViewProtocol

protocol SplashViewProtocol: BaseViewProtocol, AnyObject {
    var presenter: SplashPresenterProtocol! { get set }
}

// MARK: - SplashInteractorInputProtocol

protocol SplashInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: SplashInteractorOutputProtocol? { get set }

    /// Token kontrolü + backend doğrulaması yapar
    func checkAuthStatus()
}

// MARK: - SplashInteractorOutputProtocol

protocol SplashInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject {
    /// Token geçerliyse çağrılır → Home'a yönlendir
    func didPassAuthCheck()
    /// Token yoksa veya geçersizse çağrılır → Login'e yönlendir
    func didFailAuthCheck()
}

// MARK: - SplashPresenterProtocol

protocol SplashPresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: SplashViewProtocol? { get set }
    var interactor: SplashInteractorInputProtocol? { get set }
    var router: SplashRouterProtocol? { get set }
}

// MARK: - SplashRouterProtocol

protocol SplashRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: SplashPresenterProtocol? { get set }

    func splashToLogin()
    func splashToHome()
}

// MARK: - SplashBuilderProtocol

protocol SplashBuilderProtocol: BaseBuilderProtocol, AnyObject { }
