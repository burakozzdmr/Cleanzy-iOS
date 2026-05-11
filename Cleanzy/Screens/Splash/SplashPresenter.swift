//
//  SplashPresenter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 7.11.2025.
//

import Foundation

// MARK: - SplashPresenter

final class SplashPresenter {
    weak var view: SplashViewProtocol?
    var interactor: SplashInteractorInputProtocol?
    var router: SplashRouterProtocol?
}

// MARK: - SplashPresenterProtocol

extension SplashPresenter: SplashPresenterProtocol {
    func viewDidLoad() {
        interactor?.checkAuthStatus()
    }
}

// MARK: - SplashInteractorOutputProtocol

extension SplashPresenter: SplashInteractorOutputProtocol {
    func didPassAuthCheck() {
        router?.splashToHome()
    }

    func didFailAuthCheck() {
        router?.splashToLogin()
    }
}
