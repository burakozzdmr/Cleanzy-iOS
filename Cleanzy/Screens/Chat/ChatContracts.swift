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

    func displayChats(_ items: [ChatItem])
    func deleteChat(at index: Int)
}

// MARK: - ChatInteractorInputProtocol

protocol ChatInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: ChatInteractorOutputProtocol? { get set }

    func fetchChats()
}

// MARK: - ChatInteractorOutputProtocol

protocol ChatInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject {
    func didFetchChats(_ items: [ChatItem])
}

// MARK: - ChatPresenterProtocol

protocol ChatPresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: ChatViewProtocol? { get set }
    var interactor: ChatInteractorInputProtocol? { get set }
    var router: ChatRouterProtocol? { get set }

    func didSelectChat(at index: Int)
    func didConfirmDeleteChat(at index: Int)
}

// MARK: - ChatRouterProtocol

protocol ChatRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: ChatPresenterProtocol? { get set }

    func navigateToChatDetail(with item: ChatItem)
}

// MARK: - ChatBuilderProtocol

protocol ChatBuilderProtocol: BaseBuilderProtocol, AnyObject { }
