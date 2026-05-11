//
//  ForgotPasswordPresenter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 13.11.2025.
//

import Foundation

// MARK: - ForgotPasswordPresenter

final class ForgotPasswordPresenter {
    weak var view: ForgotPasswordViewProtocol?
    var interactor: ForgotPasswordInteractorInputProtocol?
    var router: ForgotPasswordRouterProtocol?
}

// MARK: - ForgotPasswordPresenterProtocol

extension ForgotPasswordPresenter: ForgotPasswordPresenterProtocol {
    func didSendPasswordLinkTapped(with email: String) {
        view?.showLoading()
        interactor?.sendCodeRequest(for: email)
    }
    
    func didSendPasswordSuccess() {
        view?.hideLoading()
        router?.forgotPasswordToSendCodeScreen()
    }
    
    func didSendPasswordFailure(with errorMessage: String) {
        view?.hideLoading()
        view?.showAlert(
            with: .init(
                title: "HATA",
                message: "\(errorMessage)"
            )
        )
    }
}

// MARK: - ForgotPasswordInteractorOutputProtocol

extension ForgotPasswordPresenter: ForgotPasswordInteractorOutputProtocol { }
