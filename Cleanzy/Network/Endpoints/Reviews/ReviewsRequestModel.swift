//
//  ReviewsRequestModel.swift
//  Cleanzy
//

import Foundation

// MARK: - GetReviewsByCleanerIDRequestModel

struct GetReviewsByCleanerIDRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.reviewsPath + "/cleaner/\(cleanerID)" }
    var method: HTTPMethod { .GET }

    let cleanerID: Int
}

// MARK: - AddReviewRequestModel

struct AddReviewRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.reviewsPath }
    var method: HTTPMethod { .POST }

    let cleanerID: Int
    let customerID: Int
    let rating: Double
    let comment: String

    var body: Data? {
        try? JSONEncoder().encode(
            ReviewBody(cleanerID: cleanerID, customerID: customerID, rating: rating, comment: comment)
        )
    }

    private struct ReviewBody: Encodable {
        let cleanerID: Int
        let customerID: Int
        let rating: Double
        let comment: String
    }
}
