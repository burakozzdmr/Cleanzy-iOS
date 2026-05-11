//
//  FavoritesItems.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.05.2026.
//

import Foundation

// MARK: - FavoriteItem

struct FavoriteItem: Codable {
    let cleanerID: Int
    let fullName: String
    let rating: Double
    let totalReviews: Int
    let hourlyRate: Double
    let profilePhotoURL: String?

    init(from item: UserDetailItem) {
        self.cleanerID = item.id
        self.fullName = item.fullName
        self.rating = item.rating
        self.totalReviews = item.totalReviews
        self.hourlyRate = item.hourlyRate
        self.profilePhotoURL = item.profilePhotoURL
    }
}
