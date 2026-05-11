//
//  PrepareContentContracts.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 13.11.2025.
//

import Foundation

// MARK: - PrepareContentViewProtocol

protocol PrepareContentViewProtocol: BaseViewProtocol, AnyObject {
    var presenter: PrepareContentPresenterProtocol! { get set }
    
    func updateProgress(_ progress: Float)
}

// MARK: - PrepareContentInteractorInputProtocol

protocol PrepareContentInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: PrepareContentInteractorOutputProtocol? { get set }
}

// MARK: - PrepareContentInteractorOutputProtocol

protocol PrepareContentInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject { }

// MARK: - PrepareContentPresenterProtocol

protocol PrepareContentPresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: PrepareContentViewProtocol? { get set }
    var interactor: PrepareContentInteractorInputProtocol? { get set }
    var router: PrepareContentRouterProtocol? { get set }
    
    func didFinishPreparedContent()
}

// MARK: - PrepareContentRouterProtocol

protocol PrepareContentRouterProtocol: BaseRouterProtocol, AnyObject {
    func prepareContentToHomeScreen()
}

// MARK: - PrepareContentBuilderProtocol

protocol PrepareContentBuilderProtocol: BaseBuilderProtocol, AnyObject { }
