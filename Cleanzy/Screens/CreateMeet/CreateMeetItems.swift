//
//  CreateMeetItems.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - HouseSize

enum HouseSize: String, CaseIterable {
    case small  = "1+1"
    case medium = "2+1"
    case large  = "3+1"
    case ultraLarge = "4+1"

    var priceMultiplier: Double {
        switch self {
        case .small:  return 1.0
        case .medium: return 1.3
        case .large:  return 1.6
        case .ultraLarge: return 1.9
        }
    }
}

// MARK: - ExtraServiceItem

struct ExtraServiceItem {
    let id: Int
    let title: String
    let price: Int
    let icon: String
    var isEnabled: Bool

    static let defaultList: [ExtraServiceItem] = [
        .init(id: 0, title: "Cam Temizliği", price: 150, icon: "drop.fill",        isEnabled: false),
        .init(id: 1, title: "Ütü (1 Saat)",  price: 200, icon: "flame.fill",       isEnabled: false),
        .init(id: 2, title: "Bulaşık Yıkama", price: 100, icon: "cup.and.saucer.fill", isEnabled: false)
    ]
}
