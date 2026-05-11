//
//  SendCodePresenter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 14.11.2025.
//

import Foundation

// MARK: - SendCodePresenter

final class SendCodePresenter {
    weak var view: SendCodeViewProtocol?
    var interactor: SendCodeInteractorInputProtocol?
    var router: SendCodeRouterProtocol?
}

// MARK: - SendCodePresenterProtocol

extension SendCodePresenter: SendCodePresenterProtocol {
    func didLoginTapped() {
        router?.sendCodeToLoginScreen()
    }
}

// MARK: - SendCodeInteractorOutputProtocol

extension SendCodePresenter: SendCodeInteractorOutputProtocol { }
