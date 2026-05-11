//
//  FavoritesResponseModel.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - FavoriteResponseModel

struct FavoriteResponseModel: Codable {
    let id: Int?
    let favoritedUserId: Int?
    let fullName: String?
    let email: String?
    let role: UserRole?
    let profilePhotoURL: String?
    let rating: Double?
    let createdAt: String?   // ISO-8601 string — Date olursa decoder hata veriyor
}

// MARK: - Type Aliases

typealias FavoriteSuccessResponse = BaseSuccessResponse<FavoriteResponseModel>
typealias FavoriteListSuccessResponse = BaseSuccessResponse<[FavoriteResponseModel]>
typealias FavoriteDeleteSuccessResponse = BaseSuccessResponse<Bool>
