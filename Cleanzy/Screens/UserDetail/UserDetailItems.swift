//
//  UserDetailItems.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - UserDetailItem

struct UserDetailItem {
    let id: Int
    let fullName: String
    let email: String
    let rating: Double
    let totalReviews: Int
    let hourlyRate: Double
    let profilePhotoURL: String?
    let biography: String
    let services: [CleaningService]
    let schedule: [String: String]
    let serviceArea: [String]
    let isVerified: Bool
    let isAvailable: Bool

    init(from model: CleanerResponseModel) {
        self.id = model.id ?? 0
        self.fullName = model.user?.fullName ?? "Bilinmiyor"
        self.email = model.user?.email ?? ""
        self.rating = model.rating ?? 0.0
        self.totalReviews = model.totalReviews ?? 0
        self.hourlyRate = model.hourlyRate ?? 0.0
        self.profilePhotoURL = model.profilePhotoURL
        self.biography = model.biography ?? "Hakkında bilgi bulunmuyor."
        self.services = model.services ?? []
        self.schedule = model.schedule ?? [:]
        self.serviceArea = model.serviceArea ?? []
        self.isVerified = model.verified ?? false
        self.isAvailable = model.available ?? false
    }
}

// MARK: - UserDetailReviewItem

struct UserDetailReviewItem {
    let reviewerName: String
    let rating: Int
    let comment: String
}
