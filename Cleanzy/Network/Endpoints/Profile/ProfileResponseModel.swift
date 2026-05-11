//
//  ProfileResponseModel.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - ProfileResponseModel

struct ProfileResponseModel: Codable {
    // Base (her iki rol için)
    let userId: Int?
    let fullName: String?
    let email: String?
    let role: String?
    let profilePhotoURL: String?
    let verified: Bool?
    let createdAt: String?
    let currentLocation: String?

    // Customer
    let customerId: Int?
    let totalJobs: Int?

    // Cleaner
    let cleanerId: Int?
    let biography: String?
    let hourlyRate: Double?
    let rating: Double?
    let totalReviews: Int?
    let services: [String]?
    let schedule: [String: String]?
    let serviceArea: [String]?
    let available: Bool?
    let totalJobsCompleted: Int?
}

// MARK: - Type Aliases

typealias ProfileSuccessResponse = BaseSuccessResponse<ProfileResponseModel>
