//
//  ChatInteractor.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 5.12.2025.
//

import Combine
import Foundation

// MARK: - ChatInteractor

final class ChatInteractor {
    weak var presenter: ChatInteractorOutputProtocol?
    private let conversationsService: ConversationsServiceProtocol
    private var cancellables: Set<AnyCancellable> = .init()

    init(conversationsService: ConversationsServiceProtocol = ConversationsService()) {
        self.conversationsService = conversationsService
    }
}

// MARK: - ChatInteractorInputProtocol

extension ChatInteractor: ChatInteractorInputProtocol {
    func fetchChats() {
        let userId = KeychainManager.shared.userId ?? 0
        conversationsService.getConversations(request: GetConversationsRequestModel(userId: userId))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.presenter?.didFetchChats([])
                }
            } receiveValue: { [weak self] response in
                let items = response.data.map { ChatItem(from: $0) }
                self?.presenter?.didFetchChats(items)
            }
            .store(in: &cancellables)
    }

    func deleteConversation(conversationID: Int) {
        let userId = KeychainManager.shared.userId ?? 0
        let request = DeleteConversationRequestModel(conversationID: conversationID, userId: userId)
        conversationsService.deleteConversation(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.presenter?.didFailDeletingConversation(with: error.networkErrorMessage)
                }
            } receiveValue: { [weak self] _ in
                self?.presenter?.didDeleteConversation(conversationID: conversationID)
            }
            .store(in: &cancellables)
    }
}
