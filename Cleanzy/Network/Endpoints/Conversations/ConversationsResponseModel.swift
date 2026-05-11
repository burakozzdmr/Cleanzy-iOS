//
//  ConversationsResponseModel.swift
//  Cleanzy
//

import Foundation

// MARK: - ConversationResponseModel

struct ConversationResponseModel: Codable {
    let id: Int?
    // Backend fields (ConversationResponseDTO)
    let otherUserId: Int?
    let otherUserName: String?
    let otherUserPhotoURL: String?
    let otherUserIsOnline: Bool?
    let lastMessage: String?
    let lastMessageAt: String?
    let unreadCount: Int?
    // Legacy aliases kept for backward compatibility
    var participantName: String? { otherUserName }
    var participantPhotoURL: String? { otherUserPhotoURL }
    var lastMessageTime: String? { lastMessageAt }
    var isOnline: Bool? { otherUserIsOnline }
}

// MARK: - MessageResponseModel

struct MessageResponseModel: Codable {
    let id: Int?
    let conversationId: Int?
    let senderId: Int?
    let senderName: String?
    let senderPhotoURL: String?
    let content: String?
    let sentAt: String?
    let isRead: Bool?
    let isMine: Bool?
}

// MARK: - Type Aliases

typealias ConversationSuccessResponse     = BaseSuccessResponse<ConversationResponseModel>
typealias ConversationListSuccessResponse = BaseSuccessResponse<[ConversationResponseModel]>
typealias MessageSuccessResponse          = BaseSuccessResponse<MessageResponseModel>
typealias MessageListSuccessResponse      = BaseSuccessResponse<[MessageResponseModel]>
typealias DeleteConversationResponse      = BaseSuccessResponse<Bool>
