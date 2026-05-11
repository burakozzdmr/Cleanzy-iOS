//
//  ReviewsResponseModel.swift
//  Cleanzy
//

import Foundation

// MARK: - ReviewResponseModel

struct ReviewResponseModel: Codable {
    let id: Int?
    let cleanerID: Int?
    let customerID: Int?
    let reviewerName: String?
    let rating: Double?
    let comment: String?
    let createdAt: String?
}

// MARK: - Type Aliases

typealias ReviewSuccessResponse     = BaseSuccessResponse<ReviewResponseModel>
typealias ReviewListSuccessResponse = BaseSuccessResponse<[ReviewResponseModel]>
