//
//  SendCodeContracts.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 14.11.2025.
//

import Foundation

// MARK: - SendCodeViewProtocol

protocol SendCodeViewProtocol: BaseViewProtocol, AnyObject {
    var presenter: SendCodePresenterProtocol! { get set }
}

// MARK: - SendCodeInteractorInputProtocol

protocol SendCodeInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: SendCodeInteractorOutputProtocol? { get set }
}

// MARK: - SendCodeInteractorOutputProtocol

protocol SendCodeInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject { }

// MARK: - SendCodePresenterProtocol

protocol SendCodePresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: SendCodeViewProtocol? { get set }
    var interactor: SendCodeInteractorInputProtocol? { get set }
    var router: SendCodeRouterProtocol? { get set }
    
    func didLoginTapped()
}

// MARK: - SendCodeRouterProtocol

protocol SendCodeRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: SendCodePresenterProtocol? { get set }
    
    func sendCodeToLoginScreen()
}

// MARK: - SendCodeBuilderProtocol

protocol SendCodeBuilderProtocol: BaseBuilderProtocol, AnyObject { }
