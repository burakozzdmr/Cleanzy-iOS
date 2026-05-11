//
//  RegisterContracts.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 8.11.2025.
//

import Foundation

// MARK: - RegisterViewProtocol

protocol RegisterViewProtocol: BaseViewProtocol, AnyObject {
    var presenter: RegisterPresenterProtocol! { get set }
}

// MARK: - RegisterInteractorInputProtocol

protocol RegisterInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: RegisterInteractorOutputProtocol? { get set }
    
    func sendRegisterRequest(fullName: String, email: String, password: String)
}

// MARK: - RegisterInteractorOutputProtocol

protocol RegisterInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject {
    func didRegisterSuccess()
    func didRegisterFailure(with message: String)
}

// MARK: - RegisterPresenterProtocol

protocol RegisterPresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: RegisterViewProtocol? { get set }
    var interactor: RegisterInteractorInputProtocol? { get set }
    var router: RegisterRouterProtocol? { get set }
    
    func didRegisterTapped(fullName: String, email: String, password: String)
}

// MARK: - RegisterRouterProtocol

protocol RegisterRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: RegisterPresenterProtocol? { get set }
    
    func registerToPrepareContentScreen()
}

// MARK: - RegisterBuilderProtocol

protocol RegisterBuilderProtocol: BaseBuilderProtocol, AnyObject { }
