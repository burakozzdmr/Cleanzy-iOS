//
//  ChatDetailContracts.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.05.2026.
//

import Foundation

// MARK: - ChatDetailViewProtocol

protocol ChatDetailViewProtocol: BaseViewProtocol, AnyObject {
    var presenter: ChatDetailPresenterProtocol! { get set }

    func displayMessages(_ messages: [ChatMessageItem])
    func appendMessage(_ message: ChatMessageItem)
    func configureHeader(userName: String, status: String, isOnline: Bool)
}

// MARK: - ChatDetailInteractorInputProtocol

protocol ChatDetailInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: ChatDetailInteractorOutputProtocol? { get set }

    func fetchMessages(for chatItem: ChatItem)
    func sendMessage(_ text: String)
}

// MARK: - ChatDetailInteractorOutputProtocol

protocol ChatDetailInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject {
    func didFetchMessages(_ messages: [ChatMessageItem])
    func didSendMessage(_ message: ChatMessageItem)
}

// MARK: - ChatDetailPresenterProtocol

protocol ChatDetailPresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: ChatDetailViewProtocol? { get set }
    var interactor: ChatDetailInteractorInputProtocol? { get set }
    var router: ChatDetailRouterProtocol? { get set }

    func didTapSend(text: String)
    func didTapBack()
}

// MARK: - ChatDetailRouterProtocol

protocol ChatDetailRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: ChatDetailPresenterProtocol? { get set }

    func navigateBack()
}

// MARK: - ChatDetailBuilderProtocol

protocol ChatDetailBuilderProtocol: AnyObject {
    static func createModule(with item: ChatItem) -> ChatDetailViewController
}
