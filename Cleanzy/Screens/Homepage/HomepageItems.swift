//
//  HomepageItems.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - HomepageCleanerItem

struct HomepageCleanerItem {
    let id: Int
    let fullName: String
    let rating: Double
    let totalReviews: Int
    let hourlyRate: Double
    let profilePhotoURL: String?

    init(from model: CleanerResponseModel) {
        self.id = model.id ?? 0
        self.fullName = model.user?.fullName ?? "Bilinmiyor"
        self.rating = model.rating ?? 0.0
        self.totalReviews = model.totalReviews ?? 0
        self.hourlyRate = model.hourlyRate ?? 0.0
        self.profilePhotoURL = model.profilePhotoURL
    }
}

// MARK: - HomepageServiceItem

struct HomepageServiceItem {
    let service: CleaningService
    let icon: String
    let displayName: String
    let description: String

    static let all: [HomepageServiceItem] = [
        .init(service: .HOME_CLEANING,   icon: "house.fill",       displayName: "Ev Temizliği",      description: "Genel ve detaylı"),
        .init(service: .OFFICE_CLEANING, icon: "building.2.fill",  displayName: "Ofis Temizliği",    description: "Çalışma alanları"),
        .init(service: .WINDOW_CLEANING, icon: "drop.fill",        displayName: "Cam Temizliği",     description: "Kapsamlı yıkama"),
        .init(service: .DEEP_CLEANING,   icon: "sparkles",         displayName: "Derin Temizlik",    description: "Hijyen odaklı"),
        .init(service: .MOVING_CLEANUP,  icon: "shippingbox.fill", displayName: "Taşınma Temizliği", description: "Yeni ev hazırlık")
    ]
}
