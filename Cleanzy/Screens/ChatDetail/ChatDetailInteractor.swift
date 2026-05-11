//
//  ChatDetailInteractor.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.05.2026.
//

import Combine
import Foundation

// MARK: - ChatDetailInteractor

final class ChatDetailInteractor {
    weak var presenter: ChatDetailInteractorOutputProtocol?
    private let conversationsService: ConversationsServiceProtocol
    private var conversationID: Int = 0
    private var cancellables: Set<AnyCancellable> = .init()

    init(conversationsService: ConversationsServiceProtocol = ConversationsService()) {
        self.conversationsService = conversationsService
    }
}

// MARK: - ChatDetailInteractorInputProtocol

extension ChatDetailInteractor: ChatDetailInteractorInputProtocol {
    func fetchMessages(for chatItem: ChatItem) {
        self.conversationID = chatItem.conversationID

        let request = GetMessagesByConversationIDRequestModel(conversationID: chatItem.conversationID)
        conversationsService.getMessages(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self, chatItem] completion in
                if case .failure = completion {
                    // Fallback: use mock data if backend is unavailable
                    self?.presenter?.didFetchMessages(ChatMessageItem.mockMessages(for: chatItem))
                }
            } receiveValue: { [weak self] response in
                let currentUserId = KeychainManager.shared.userId ?? 0
                let messages: [ChatMessageItem] = response.data.map { model in
                    let isMine = (model.senderUserId ?? -1) == currentUserId
                    let time   = model.sentAt ?? ""
                    return ChatMessageItem(text: model.content ?? "", time: time, isSentByMe: isMine)
                }
                let grouped = ChatDetailInteractor.insertDateSeparators(for: messages)
                self?.presenter?.didFetchMessages(grouped)
            }
            .store(in: &cancellables)
    }

    func sendMessage(_ text: String) {
        let now     = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
        let message = ChatMessageItem(text: text, time: now, isSentByMe: true)
        // Optimistically show the message immediately
        presenter?.didSendMessage(message)

        guard conversationID != 0 else { return }
        let request = SendMessageRequestModel(conversationID: conversationID, content: text)
        conversationsService.sendMessage(request: request)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}

// MARK: - Private Helpers

private extension ChatDetailInteractor {
    static func insertDateSeparators(for messages: [ChatMessageItem]) -> [ChatMessageItem] {
        var result: [ChatMessageItem] = []
        var lastDate: String = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        formatter.locale = Locale(identifier: "tr_TR")

        for message in messages {
            let day = String(message.time.prefix(10))
            if day != lastDate && !day.isEmpty {
                lastDate = day
                if let date = ISO8601DateFormatter().date(from: message.time) {
                    result.append(.dateSeparator(formatter.string(from: date)))
                }
            }
            result.append(message)
        }
        return result
    }
}
