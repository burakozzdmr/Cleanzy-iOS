//
//  LoginContracts.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 8.11.2025.
//

import Foundation

// MARK: - LoginViewProtocol

protocol LoginViewProtocol: BaseViewProtocol, AnyObject {
    var presenter: LoginPresenterProtocol! { get set }
}

// MARK: - LoginInteractorInputProtocol

protocol LoginInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: LoginInteractorOutputProtocol? { get set }
    
    func sendLoginRequest(with email: String, and password: String, as userTypeIndex: Int)
}

// MARK: - LoginInteractorOutputProtocol

protocol LoginInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject {
    func didLoginSuccess()
    func didLoginFailure(with message: String)
}

// MARK: - LoginPresenterProtocol

protocol LoginPresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: LoginViewProtocol? { get set }
    var interactor: LoginInteractorInputProtocol? { get set }
    var router: LoginRouterProtocol? { get set }
    
    func didLoginTapped(with email: String, and password: String, as userTypeIndex: Int)
    func didForgotPasswordTapped()
    func didRegisterTapped()
}

// MARK: - LoginRouterProtocol

protocol LoginRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: LoginPresenterProtocol? { get set }
    
    func loginToHomeScreen()
    func loginToForgotPasswordScreen()
    func loginToRegisterScreen()
}

// MARK: - LoginBuilderProtocol

protocol LoginBuilderProtocol: BaseBuilderProtocol, AnyObject { }
