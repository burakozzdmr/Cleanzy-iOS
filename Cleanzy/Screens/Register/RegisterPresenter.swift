//
//  RegisterPresenter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 8.11.2025.
//

import Foundation

// MARK: - RegisterPresenter

final class RegisterPresenter {
    weak var view: RegisterViewProtocol?
    var interactor: RegisterInteractorInputProtocol?
    var router: RegisterRouterProtocol?
}

// MARK: - RegisterPresenterProtocol

extension RegisterPresenter: RegisterPresenterProtocol {
    func didRegisterTapped(fullName: String, email: String, password: String) {
        view?.showLoading()
        interactor?.sendRegisterRequest(fullName: fullName, email: email, password: password)
    }
}

// MARK: - RegisterInteractorOutputProtocol

extension RegisterPresenter: RegisterInteractorOutputProtocol {
    func didRegisterSuccess() {
        view?.hideLoading()
        router?.registerToPrepareContentScreen()
    }
    
    func didRegisterFailure(with message: String) {
        view?.hideLoading()
        view?.showAlert(with: .init(title: "Kayıt Hatası", message: message))
    }
}
