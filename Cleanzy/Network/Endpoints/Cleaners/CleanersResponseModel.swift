//
//  CleanersResponseModel.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - CleanerResponseModel

struct CleanerResponseModel: Codable {
    let id: Int?
    let user: UserSummaryModel?
    let biography: String?
    let currentLocation: String?
    let rating: Double?
    let totalReviews: Int?
    let hourlyRate: Double?
    let serviceArea: [String]?
    let profilePhotoURL: String?
    let schedule: [String: String]?
    let services: [CleaningService]?
    let verified: Bool?
    let available: Bool?
}

// MARK: - Type Aliases

typealias CleanerSuccessResponse = BaseSuccessResponse<CleanerResponseModel>
typealias CleanerListSuccessResponse = BaseSuccessResponse<[CleanerResponseModel]>
