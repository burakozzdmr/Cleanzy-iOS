//
//  ConversationsService.swift
//  Cleanzy
//

import Combine
import Foundation

// MARK: - ConversationsServiceProtocol

protocol ConversationsServiceProtocol {
    func getConversations(request: GetConversationsRequestModel) -> AnyPublisher<ConversationListSuccessResponse, NetworkError>
    func getMessages(request: GetMessagesByConversationIDRequestModel) -> AnyPublisher<MessageListSuccessResponse, NetworkError>
    func sendMessage(request: SendMessageRequestModel) -> AnyPublisher<MessageSuccessResponse, NetworkError>
    func createConversation(request: CreateConversationRequestModel) -> AnyPublisher<ConversationSuccessResponse, NetworkError>
    func deleteConversation(request: DeleteConversationRequestModel) -> AnyPublisher<DeleteConversationResponse, NetworkError>
}

// MARK: - ConversationsService

final class ConversationsService: ConversationsServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
}

// MARK: - Methods

extension ConversationsService {
    func getConversations(request: GetConversationsRequestModel) -> AnyPublisher<ConversationListSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: ConversationListSuccessResponse.self)
    }

    func getMessages(request: GetMessagesByConversationIDRequestModel) -> AnyPublisher<MessageListSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: MessageListSuccessResponse.self)
    }

    func sendMessage(request: SendMessageRequestModel) -> AnyPublisher<MessageSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: MessageSuccessResponse.self)
    }

    func createConversation(request: CreateConversationRequestModel) -> AnyPublisher<ConversationSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: ConversationSuccessResponse.self)
    }

    func deleteConversation(request: DeleteConversationRequestModel) -> AnyPublisher<DeleteConversationResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: DeleteConversationResponse.self)
    }
}
