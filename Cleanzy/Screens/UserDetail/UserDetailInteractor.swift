//
//  UserDetailInteractor.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Combine
import Foundation

// MARK: - UserDetailInteractor

final class UserDetailInteractor {
    weak var presenter: UserDetailInteractorOutputProtocol?
    private let cleanersService: CleanersServiceProtocol
    private let reviewsService: ReviewsServiceProtocol
    private var cancellables: Set<AnyCancellable> = .init()

    init(
        cleanersService: CleanersServiceProtocol = CleanersService(),
        reviewsService: ReviewsServiceProtocol = ReviewsService()
    ) {
        self.cleanersService = cleanersService
        self.reviewsService  = reviewsService
    }
}

// MARK: - UserDetailInteractorInputProtocol

extension UserDetailInteractor: UserDetailInteractorInputProtocol {
    func fetchCleanerDetail(cleanerID: Int) {
        cleanersService.getCleanerByID(request: GetCleanerByIDRequestModel(cleanerID: cleanerID))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.presenter?.didFailFetchingDetail(with: error.networkErrorMessage)
                }
            } receiveValue: { [weak self] response in
                self?.presenter?.didFetchCleanerDetail(response.data)
            }
            .store(in: &cancellables)
    }

    func fetchReviews(cleanerID: Int) {
        reviewsService.getReviewsByCleanerID(request: GetReviewsByCleanerIDRequestModel(cleanerID: cleanerID))
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] response in
                let reviews = response.data.map { model -> UserDetailReviewItem in
                    UserDetailReviewItem(
                        reviewerName: model.reviewerName ?? "Anonim",
                        rating: Int(model.rating ?? 0),
                        comment: model.comment ?? ""
                    )
                }
                self?.presenter?.didFetchReviews(reviews)
            }
            .store(in: &cancellables)
    }
}
