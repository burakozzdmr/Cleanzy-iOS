//
//  ConversationsRequestModel.swift
//  Cleanzy
//

import Foundation

// MARK: - GetConversationsRequestModel

struct GetConversationsRequestModel: BaseRequest {
    let userId: Int

    var path: String {
        "\(NetworkConstants.Endpoints.conversationsPath)?userId=\(userId)"
    }
    var method: HTTPMethod { .GET }
}

// MARK: - GetMessagesByConversationIDRequestModel

struct GetMessagesByConversationIDRequestModel: BaseRequest {
    let conversationID: Int
    let currentUserId: Int

    var path: String {
        "\(NetworkConstants.Endpoints.conversationsPath)/\(conversationID)/messages?currentUserId=\(currentUserId)"
    }
    var method: HTTPMethod { .GET }
}

// MARK: - SendMessageRequestModel

struct SendMessageRequestModel: BaseRequest {
    let conversationID: Int
    let senderId: Int
    let content: String

    var path: String {
        "\(NetworkConstants.Endpoints.conversationsPath)/\(conversationID)/messages"
    }
    var method: HTTPMethod { .POST }

    var body: Data? {
        try? JSONEncoder().encode(MessageBody(senderId: senderId, content: content))
    }

    private struct MessageBody: Encodable {
        let senderId: Int
        let content: String
    }
}

// MARK: - CreateConversationRequestModel

struct CreateConversationRequestModel: BaseRequest {
    let currentUserId: Int
    let participantId: Int

    var path: String {
        "\(NetworkConstants.Endpoints.conversationsPath)?currentUserId=\(currentUserId)"
    }
    var method: HTTPMethod { .POST }

    var body: Data? {
        try? JSONEncoder().encode(ConversationBody(participantId: participantId))
    }

    private struct ConversationBody: Encodable {
        let participantId: Int
    }
}

// MARK: - DeleteConversationRequestModel

struct DeleteConversationRequestModel: BaseRequest {
    let conversationID: Int
    let userId: Int

    var path: String {
        "\(NetworkConstants.Endpoints.conversationsPath)/\(conversationID)?userId=\(userId)"
    }
    var method: HTTPMethod { .DELETE }
}
