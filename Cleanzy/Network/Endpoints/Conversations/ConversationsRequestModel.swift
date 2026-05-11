//
//  ConversationsRequestModel.swift
//  Cleanzy
//

import Foundation

// MARK: - GetConversationsRequestModel

struct GetConversationsRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.conversationsPath }
    var method: HTTPMethod { .GET }
}

// MARK: - GetMessagesByConversationIDRequestModel

struct GetMessagesByConversationIDRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.conversationsPath + "/\(conversationID)/messages" }
    var method: HTTPMethod { .GET }

    let conversationID: Int
}

// MARK: - SendMessageRequestModel

struct SendMessageRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.conversationsPath + "/\(conversationID)/messages" }
    var method: HTTPMethod { .POST }

    let conversationID: Int
    let content: String

    var body: Data? {
        try? JSONEncoder().encode(MessageBody(content: content))
    }

    private struct MessageBody: Encodable {
        let content: String
    }
}

// MARK: - CreateConversationRequestModel

struct CreateConversationRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.conversationsPath }
    var method: HTTPMethod { .POST }

    let participantUserId: Int

    var body: Data? {
        try? JSONEncoder().encode(ConversationBody(participantUserId: participantUserId))
    }

    private struct ConversationBody: Encodable {
        let participantUserId: Int
    }
}

// MARK: - DeleteConversationRequestModel

struct DeleteConversationRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.conversationsPath + "/\(conversationID)" }
    var method: HTTPMethod { .DELETE }

    let conversationID: Int
}
