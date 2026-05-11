//
//  ChatDetailPresenter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.05.2026.
//

import Foundation

// MARK: - ChatDetailPresenter

final class ChatDetailPresenter {
    weak var view: ChatDetailViewProtocol?
    var interactor: ChatDetailInteractorInputProtocol?
    var router: ChatDetailRouterProtocol?

    private let chatItem: ChatItem

    init(chatItem: ChatItem) {
        self.chatItem = chatItem
    }
}

// MARK: - ChatDetailPresenterProtocol

extension ChatDetailPresenter: ChatDetailPresenterProtocol {
    func viewDidLoad() {
        let status = chatItem.isOnline ? "Çevrimiçi · Yanıt süresi: 5 dk" : "Çevrimdışı"
        view?.configureHeader(userName: chatItem.userName, status: status, isOnline: chatItem.isOnline)
        interactor?.fetchMessages(for: chatItem)
    }

    func didTapSend(text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        interactor?.sendMessage(trimmed)
    }

    func didTapBack() {
        router?.navigateBack()
    }
}

// MARK: - ChatDetailInteractorOutputProtocol

extension ChatDetailPresenter: ChatDetailInteractorOutputProtocol {
    func didFetchMessages(_ messages: [ChatMessageItem]) {
        view?.displayMessages(messages)
    }

    func didSendMessage(_ message: ChatMessageItem) {
        view?.appendMessage(message)
    }
}
