//
//  CustomersResponseModel.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - CustomerResponseModel

struct CustomerResponseModel: Codable {
    let id: Int?
    let user: UserSummaryModel?
    let currentLocation: String?
    let rating: Double?
    let totalReviews: Int?
    let profilePhotoURL: String?
    let verified: Bool?
}

// MARK: - Type Aliases

typealias CustomerSuccessResponse = BaseSuccessResponse<CustomerResponseModel>
typealias CustomerListSuccessResponse = BaseSuccessResponse<[CustomerResponseModel]>
