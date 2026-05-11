//
//  FavoritesItems.swift
//  Cleanzy
//

import Foundation

// MARK: - FavoriteItem

struct FavoriteItem: Codable {
    let cleanerID: Int
    /// Backend user ID of the favorited person.
    /// May differ from cleanerID (cleaner profile ID).
    let favoritedUserId: Int?
    let fullName: String
    let rating: Double
    let totalReviews: Int
    let hourlyRate: Double
    let profilePhotoURL: String?

    // From UserDetailItem (local toggle)
    init(from item: UserDetailItem) {
        self.cleanerID       = item.id
        self.favoritedUserId = nil  // Will be set when synced with backend
        self.fullName        = item.fullName
        self.rating          = item.rating
        self.totalReviews    = item.totalReviews
        self.hourlyRate      = item.hourlyRate
        self.profilePhotoURL = item.profilePhotoURL
    }

    // From backend FavoriteResponseModel
    init(from model: FavoriteResponseModel) {
        self.cleanerID       = model.favoritedUserId ?? 0
        self.favoritedUserId = model.favoritedUserId
        self.fullName        = model.fullName ?? ""
        self.rating          = model.rating ?? 0
        self.totalReviews    = 0
        self.hourlyRate      = 0
        self.profilePhotoURL = model.profilePhotoURL
    }
}
