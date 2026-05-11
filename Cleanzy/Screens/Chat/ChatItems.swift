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
    let userName: String
    let lastMessage: String
    let time: String
    let unreadCount: Int
    let profilePhotoURL: String?
    let isOnline: Bool
    let groupInitials: String?

    static let mockList: [ChatItem] = [
        ChatItem(id: 1, userName: "Ayşe Y.", lastMessage: "Merhaba, yarın saat 2'de uygun...", time: "10:30", unreadCount: 2, profilePhotoURL: nil, isOnline: true, groupInitials: nil),
        ChatItem(id: 2, userName: "Mehmet T.", lastMessage: "Teşekkürler, görüşmek üzere.", time: "Dün", unreadCount: 0, profilePhotoURL: nil, isOnline: false, groupInitials: nil),
        ChatItem(id: 3, userName: "Elif K.", lastMessage: "✓✓ Randevunuz onaylandı.", time: "Pzt", unreadCount: 0, profilePhotoURL: nil, isOnline: false, groupInitials: nil),
        ChatItem(id: 4, userName: "Can B.", lastMessage: "Konumu gönderdim, bekliyorum.", time: "Pzt", unreadCount: 0, profilePhotoURL: nil, isOnline: false, groupInitials: nil),
        ChatItem(id: 5, userName: "Zeynep S.", lastMessage: "Tamamdır, anlaştık.", time: "2 Haz", unreadCount: 0, profilePhotoURL: nil, isOnline: false, groupInitials: nil),
        ChatItem(id: 6, userName: "Temizlik Ekibi", lastMessage: "Kampanya kodunuz tanımlandı.", time: "1 Haz", unreadCount: 0, profilePhotoURL: nil, isOnline: false, groupInitials: "EK")
    ]
}
