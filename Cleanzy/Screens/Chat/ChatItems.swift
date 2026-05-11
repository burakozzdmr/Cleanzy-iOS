//
//  ChatItems.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.05.2026.
//

import Foundation

// MARK: - ChatItem

struct ChatItem {
    let id: Int
    let conversationID: Int
    let userName: String
    let lastMessage: String
    let time: String
    let unreadCount: Int
    let profilePhotoURL: String?
    let isOnline: Bool
    let groupInitials: String?

    init(from model: ConversationResponseModel) {
        self.id               = model.id ?? 0
        self.conversationID   = model.id ?? 0
        self.userName         = model.participantName ?? "Bilinmiyor"
        self.lastMessage      = model.lastMessage ?? ""
        self.time             = model.lastMessageTime ?? ""
        self.unreadCount      = model.unreadCount ?? 0
        self.profilePhotoURL  = model.participantPhotoURL
        self.isOnline         = model.isOnline ?? false
        self.groupInitials    = nil
    }

    // Fallback for tests / offline scenarios
    init(id: Int, conversationID: Int = 0, userName: String, lastMessage: String, time: String,
         unreadCount: Int, profilePhotoURL: String?, isOnline: Bool, groupInitials: String?) {
        self.id              = id
        self.conversationID  = conversationID
        self.userName        = userName
        self.lastMessage     = lastMessage
        self.time            = time
        self.unreadCount     = unreadCount
        self.profilePhotoURL = profilePhotoURL
        self.isOnline        = isOnline
        self.groupInitials   = groupInitials
    }
}
