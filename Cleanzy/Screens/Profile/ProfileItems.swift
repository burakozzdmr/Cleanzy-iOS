//
//  ProfileItems.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.05.2026.
//

import UIKit

// MARK: - ProfileSection

enum ProfileSection: Int, CaseIterable {
    case account
    case settings
    case other

    var title: String {
        switch self {
        case .account:  return "HESAP"
        case .settings: return "AYARLAR"
        case .other:    return "DİĞER"
        }
    }

    var rows: [ProfileRow] {
        switch self {
        case .account:  return [.editProfile, .myAppointments, .verifyProfile]
        case .settings: return [.paymentMethods, .addresses, .notifications, .appSettings]
        case .other:    return [.helpSupport, .logout]
        }
    }
}

// MARK: - ProfileRow

enum ProfileRow {
    case editProfile
    case myAppointments
    case verifyProfile
    case paymentMethods
    case addresses
    case notifications
    case appSettings
    case helpSupport
    case logout

    var title: String {
        switch self {
        case .editProfile:      return "Profilimi Düzenle"
        case .myAppointments:   return "Randevularım"
        case .verifyProfile:    return "Profilini Doğrula"
        case .paymentMethods:   return "Ödeme Yöntemlerim"
        case .addresses:        return "Adreslerim"
        case .notifications:    return "Bildirim Ayarları"
        case .appSettings:      return "Uygulama Ayarları"
        case .helpSupport:      return "Yardım ve Destek"
        case .logout:           return "Çıkış Yap"
        }
    }

    var subtitle: String? {
        switch self {
        case .myAppointments: return nil
        case .verifyProfile:  return "Kimliğinizi doğrulayın"
        default:              return nil
        }
    }

    var iconName: String {
        switch self {
        case .editProfile:      return "pencil"
        case .myAppointments:   return "calendar.badge.clock"
        case .verifyProfile:    return "checkmark.shield.fill"
        case .paymentMethods: return "creditcard.fill"
        case .addresses:      return "location.fill"
        case .notifications:  return "bell.fill"
        case .appSettings:    return "gearshape.fill"
        case .helpSupport:    return "questionmark.circle.fill"
        case .logout:         return "rectangle.portrait.and.arrow.right"
        }
    }

    var iconBackgroundColor: UIColor {
        switch self {
        case .editProfile:      return UIColor.accent
        case .myAppointments:   return UIColor(red: 0.36, green: 0.20, blue: 0.90, alpha: 1.0)
        case .verifyProfile:    return UIColor(red: 0.18, green: 0.72, blue: 0.34, alpha: 1.0)
        case .paymentMethods: return UIColor(red: 0.20, green: 0.46, blue: 0.90, alpha: 1.0)
        case .addresses:      return UIColor(red: 0.98, green: 0.45, blue: 0.28, alpha: 1.0)
        case .notifications:  return UIColor(red: 0.98, green: 0.70, blue: 0.10, alpha: 1.0)
        case .appSettings:    return UIColor(red: 0.40, green: 0.44, blue: 0.52, alpha: 1.0)
        case .helpSupport:    return UIColor.accent
        case .logout:         return UIColor(red: 0.95, green: 0.25, blue: 0.25, alpha: 1.0)
        }
    }

    var isDestructive: Bool { self == .logout }
}
