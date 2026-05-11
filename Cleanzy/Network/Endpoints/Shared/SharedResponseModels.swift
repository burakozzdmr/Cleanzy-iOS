//
//  SharedResponseModels.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - UserSummaryModel

struct UserSummaryModel: Codable {
    let fullName: String?
    let email: String?
}

// MARK: - CustomerSummaryModel

struct CustomerSummaryModel: Codable {
    let id: Int?
    let fullName: String?
    let currentLocation: String?
    let rating: Double?
}

// MARK: - CleanerSummaryModel

struct CleanerSummaryModel: Codable {
    let id: Int?
    let fullName: String?
    let currentLocation: String?
    let rating: Double?
    let ibanNumber: String?
    let hourlyRate: Double?
    let services: [CleaningService]?
    let biography: String?
}

// MARK: - CleaningService

enum CleaningService: String, Codable {
    case HOME_CLEANING
    case OFFICE_CLEANING
    case WINDOW_CLEANING
    case DEEP_CLEANING
    case MOVING_CLEANUP

    var displayName: String {
        switch self {
        case .HOME_CLEANING:   return "Ev Temizliği"
        case .OFFICE_CLEANING: return "Ofis Temizliği"
        case .WINDOW_CLEANING: return "Cam Temizliği"
        case .DEEP_CLEANING:   return "Derin Temizlik"
        case .MOVING_CLEANUP:  return "Taşınma Temizliği"
        }
    }

    var icon: String {
        switch self {
        case .HOME_CLEANING:   return "house.fill"
        case .OFFICE_CLEANING: return "building.2.fill"
        case .WINDOW_CLEANING: return "drop.fill"
        case .DEEP_CLEANING:   return "sparkles"
        case .MOVING_CLEANUP:  return "shippingbox.fill"
        }
    }
}

// MARK: - UserRole

enum UserRole: String, Codable {
    case CUSTOMER
    case CLEANER
}
