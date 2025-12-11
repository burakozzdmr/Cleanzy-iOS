//
//  ChatContracts.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 5.12.2025.
//

import Foundation

// MARK: - ChatViewProtocol

protocol ChatViewProtocol: BaseViewProtocol, AnyObject {
    var presenter: ChatPresenterProtocol! { get set }
}

// MARK: - ChatInteractorInputProtocol

protocol ChatInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: ChatInteractorOutputProtocol? { get set }
}

// MARK: - ChatInteractorOutputProtocol

protocol ChatInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject {
    
}

// MARK: - ChatPresenterProtocol

protocol ChatPresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: ChatViewProtocol? { get set }
    var interactor: ChatInteractorInputProtocol? { get set }
    var router: ChatRouterProtocol? { get set }
}

// MARK: - ChatRouterProtocol

protocol ChatRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: ChatPresenterProtocol? { get set }
}

// MARK: - ChatBuilderProtocol

protocol ChatBuilderProtocol: BaseBuilderProtocol, AnyObject { }
