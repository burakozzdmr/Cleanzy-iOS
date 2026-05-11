//
//  ReviewsService.swift
//  Cleanzy
//

import Combine
import Foundation

// MARK: - ReviewsServiceProtocol

protocol ReviewsServiceProtocol {
    func getReviewsByCleanerID(request: GetReviewsByCleanerIDRequestModel) -> AnyPublisher<ReviewListSuccessResponse, NetworkError>
    func addReview(request: AddReviewRequestModel) -> AnyPublisher<ReviewSuccessResponse, NetworkError>
}

// MARK: - ReviewsService

final class ReviewsService: ReviewsServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
}

// MARK: - Methods

extension ReviewsService {
    func getReviewsByCleanerID(request: GetReviewsByCleanerIDRequestModel) -> AnyPublisher<ReviewListSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: ReviewListSuccessResponse.self)
    }

    func addReview(request: AddReviewRequestModel) -> AnyPublisher<ReviewSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: ReviewSuccessResponse.self)
    }
}
