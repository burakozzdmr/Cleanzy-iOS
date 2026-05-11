//
//  PaymentMethodsItems.swift
//  Cleanzy
//

import UIKit

// MARK: - CardBrand

enum CardBrand {
    case visa, mastercard, other

    var icon: UIImage? {
        switch self {
        case .visa:       return UIImage(systemName: "creditcard.fill")
        case .mastercard: return UIImage(systemName: "creditcard.fill")
        case .other:      return UIImage(systemName: "creditcard")
        }
    }

    var tintColor: UIColor {
        switch self {
        case .visa:       return UIColor(red: 0.07, green: 0.29, blue: 0.72, alpha: 1)
        case .mastercard: return UIColor(red: 0.93, green: 0.27, blue: 0.13, alpha: 1)
        case .other:      return .systemGray
        }
    }

    static func detect(from number: String) -> CardBrand {
        if number.hasPrefix("4") { return .visa }
        if number.hasPrefix("5") || number.hasPrefix("2") { return .mastercard }
        return .other
    }
}

// MARK: - PaymentCardItem

struct PaymentCardItem {
    let id: UUID
    let holderName: String
    let maskedNumber: String  // e.g. "**** **** **** 4242"
    let expiryDate: String    // e.g. "12/27"
    let isDefault: Bool
    let brand: CardBrand

    init(holderName: String, lastFour: String, expiryDate: String, isDefault: Bool = false) {
        self.id           = UUID()
        self.holderName   = holderName
        self.maskedNumber = "**** **** **** \(lastFour)"
        self.expiryDate   = expiryDate
        self.isDefault    = isDefault
        self.brand        = CardBrand.detect(from: lastFour)
    }
}
