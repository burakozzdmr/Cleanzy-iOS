//
//  ForgotPasswordContracts.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 13.11.2025.
//

import Foundation

// MARK: - ForgotPasswordViewProtocol

protocol ForgotPasswordViewProtocol: BaseViewProtocol, AnyObject {
    var presenter: ForgotPasswordPresenterProtocol! { get set }
}

// MARK: - ForgotPasswordInteractorInputProtocol

protocol ForgotPasswordInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: ForgotPasswordInteractorOutputProtocol? { get set }
    
    func sendCodeRequest(for emailText: String)
}

// MARK: - ForgotPasswordInteractorOutputProtocol

protocol ForgotPasswordInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject {
    func didSendPasswordSuccess()
    func didSendPasswordFailure(with errorMessage: String)
}

// MARK: - ForgotPasswordPresenterProtocol

protocol ForgotPasswordPresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: ForgotPasswordViewProtocol? { get set }
    var interactor: ForgotPasswordInteractorInputProtocol? { get set }
    var router: ForgotPasswordRouterProtocol? { get set }
    
    func didSendPasswordLinkTapped(with email: String)
}

// MARK: - ForgotPasswordRouterProtocol

protocol ForgotPasswordRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: ForgotPasswordPresenterProtocol? { get set }
    
    func forgotPasswordToSendCodeScreen()
}

// MARK: - ForgotPasswordBuilderProtocol

protocol ForgotPasswordBuilderProtocol: BaseBuilderProtocol, AnyObject { }
