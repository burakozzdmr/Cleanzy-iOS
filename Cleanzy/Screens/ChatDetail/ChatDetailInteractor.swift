//
//  ChatDetailInteractor.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.05.2026.
//

import Foundation

// MARK: - ChatDetailInteractor

final class ChatDetailInteractor {
    weak var presenter: ChatDetailInteractorOutputProtocol?
}

// MARK: - ChatDetailInteractorInputProtocol

extension ChatDetailInteractor: ChatDetailInteractorInputProtocol {
    func fetchMessages(for chatItem: ChatItem) {
        presenter?.didFetchMessages(ChatMessageItem.mockMessages(for: chatItem))
    }

    func sendMessage(_ text: String) {
        let now = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
        let message = ChatMessageItem(text: text, time: now, isSentByMe: true)
        presenter?.didSendMessage(message)
    }
}
