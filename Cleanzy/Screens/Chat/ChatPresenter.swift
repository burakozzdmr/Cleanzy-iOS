//
//  ChatPresenter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 5.12.2025.
//

import Foundation

// MARK: - ChatPresenter

final class ChatPresenter {
    weak var view: ChatViewProtocol?
    var interactor: ChatInteractorInputProtocol?
    var router: ChatRouterProtocol?

    private var items: [ChatItem] = []
}

// MARK: - ChatPresenterProtocol

extension ChatPresenter: ChatPresenterProtocol {
    func viewDidLoad() {
        interactor?.fetchChats()
    }

    func didSelectChat(at index: Int) {
        guard index < items.count else { return }
        router?.navigateToChatDetail(with: items[index])
    }

    func didConfirmDeleteChat(at index: Int) {
        guard index < items.count else { return }
        let item = items[index]
        interactor?.deleteConversation(conversationID: item.conversationID)
    }
}

// MARK: - ChatInteractorOutputProtocol

extension ChatPresenter: ChatInteractorOutputProtocol {
    func didFetchChats(_ items: [ChatItem]) {
        self.items = items
        view?.displayChats(items)
    }

    func didDeleteConversation(conversationID: Int) {
        guard let index = items.firstIndex(where: { $0.conversationID == conversationID }) else { return }
        items.remove(at: index)
        view?.deleteChat(at: index)
    }

    func didFailDeletingConversation(with message: String) {
        view?.showAlert(with: .init(title: "Hata", message: message))
    }
}
