//
//  ConversationsResponseModel.swift
//  Cleanzy
//

import Foundation

// MARK: - ConversationResponseModel

struct ConversationResponseModel: Codable {
    let id: Int?
    let participantName: String?
    let participantPhotoURL: String?
    let lastMessage: String?
    let lastMessageTime: String?
    let unreadCount: Int?
    let isOnline: Bool?
}

// MARK: - MessageResponseModel

struct MessageResponseModel: Codable {
    let id: Int?
    let senderUserId: Int?
    let senderName: String?
    let content: String?
    let sentAt: String?
    let isRead: Bool?
}

// MARK: - Type Aliases

typealias ConversationSuccessResponse     = BaseSuccessResponse<ConversationResponseModel>
typealias ConversationListSuccessResponse = BaseSuccessResponse<[ConversationResponseModel]>
typealias MessageSuccessResponse          = BaseSuccessResponse<MessageResponseModel>
typealias MessageListSuccessResponse      = BaseSuccessResponse<[MessageResponseModel]>
typealias DeleteConversationResponse      = BaseSuccessResponse<Bool>
