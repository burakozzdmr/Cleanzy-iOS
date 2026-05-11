//
//  ChatDetailItems.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.05.2026.
//

import Foundation

// MARK: - ChatMessageItem

struct ChatMessageItem {
    let id: UUID
    let text: String
    let time: String
    let isSentByMe: Bool
    let isDateSeparator: Bool
    let dateText: String?

    init(
        text: String,
        time: String,
        isSentByMe: Bool,
        isDateSeparator: Bool = false,
        dateText: String? = nil
    ) {
        self.id = UUID()
        self.text = text
        self.time = time
        self.isSentByMe = isSentByMe
        self.isDateSeparator = isDateSeparator
        self.dateText = dateText
    }

    static func dateSeparator(_ text: String) -> ChatMessageItem {
        ChatMessageItem(text: text, time: "", isSentByMe: false, isDateSeparator: true, dateText: text)
    }

    static func mockMessages(for item: ChatItem) -> [ChatMessageItem] {
        [
            .dateSeparator("BUGÜN"),
            ChatMessageItem(text: "Merhaba! Ev temizliği için müsaitliğim var.", time: "13:45", isSentByMe: false),
            ChatMessageItem(text: "Harika, Cuma günü saat 14:00 uygun mu?", time: "13:46", isSentByMe: true),
            ChatMessageItem(text: "Evet, uygundur.", time: "13:48", isSentByMe: false),
            ChatMessageItem(text: "Adres bilgilerinizi ve temizlik yapılacak alanın büyüklüğünü paylaşabilir misiniz?", time: "13:49", isSentByMe: false)
        ]
    }
}
