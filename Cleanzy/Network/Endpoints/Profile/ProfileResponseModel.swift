//
//  ProfileResponseModel.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - ProfileResponseModel

// ProfileDTO is currently an empty schema on the backend.
// Add fields here as the backend schema evolves.
struct ProfileResponseModel: Codable {}

// MARK: - Type Aliases

typealias ProfileSuccessResponse = BaseSuccessResponse<ProfileResponseModel>
