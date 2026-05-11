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
    private let webSocketManager: WebSocketManager
    private var conversationID: Int = 0
    private var cancellables: Set<AnyCancellable> = .init()

    init(
        conversationsService: ConversationsServiceProtocol = ConversationsService(),
        webSocketManager: WebSocketManager = .shared
    ) {
        self.conversationsService = conversationsService
        self.webSocketManager     = webSocketManager
    }
}

// MARK: - ChatDetailInteractorInputProtocol

extension ChatDetailInteractor: ChatDetailInteractorInputProtocol {
    func fetchMessages(for chatItem: ChatItem) {
        self.conversationID = chatItem.conversationID
        let currentUserId = KeychainManager.shared.userId ?? 0

        let request = GetMessagesByConversationIDRequestModel(
            conversationID: chatItem.conversationID,
            currentUserId: currentUserId
        )
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
                    let isMine = model.isMine ?? ((model.senderId ?? -1) == currentUserId)
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
        // Optimistically show the message in the UI immediately
        presenter?.didSendMessage(message)

        guard conversationID != 0 else { return }
        let senderId = KeychainManager.shared.userId ?? 0

        // Send via WebSocket for real-time delivery
        webSocketManager.send(conversationId: conversationID, content: text, senderId: senderId)
    }

    func connectWebSocket() {
        guard conversationID != 0 else { return }

        webSocketManager.onMessageReceived = { [weak self] model in
            guard let self else { return }
            let currentUserId = KeychainManager.shared.userId ?? 0
            let isMine = model.isMine ?? ((model.senderId ?? -1) == currentUserId)
            // Skip messages sent by self (already shown optimistically)
            guard !isMine else { return }
            let time = model.sentAt ?? DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
            let item = ChatMessageItem(text: model.content ?? "", time: time, isSentByMe: false)
            self.presenter?.didReceiveMessage(item)
        }

        webSocketManager.connect(conversationId: conversationID)
    }

    func disconnectWebSocket() {
        webSocketManager.onMessageReceived = nil
        webSocketManager.disconnect()
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
