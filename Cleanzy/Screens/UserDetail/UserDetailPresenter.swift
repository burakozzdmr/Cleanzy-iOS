//
//  UserDetailPresenter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - UserDetailPresenter

final class UserDetailPresenter {
    weak var view: UserDetailViewProtocol?
    var interactor: UserDetailInteractorInputProtocol?
    var router: UserDetailRouterProtocol?

    private let cleanerID: Int
    private var currentItem: UserDetailItem?

    init(cleanerID: Int) {
        self.cleanerID = cleanerID
    }

    // Yorumlar endpoint mevcut olmadığından geçici mock veri
    private var mockReviews: [UserDetailReviewItem] = [
        .init(reviewerName: "Ayşe K.", rating: 5, comment: "Çok titiz ve profesyonel. Evim pırıl pırıl oldu, çok memnun kaldım."),
        .init(reviewerName: "Mehmet T.", rating: 4, comment: "Zamanında geldi ve işini hızlıca halletti. Kesinlikle tavsiye ederim.")
    ]
}

// MARK: - UserDetailPresenterProtocol

extension UserDetailPresenter: UserDetailPresenterProtocol {
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchCleanerDetail(cleanerID: cleanerID)
    }

    func didTapCreateMeet() {
        let hourlyRate = currentItem?.hourlyRate ?? 0
        router?.navigateToCreateMeet(cleanerID: cleanerID, hourlyRate: hourlyRate)
    }
}

// MARK: - UserDetailInteractorOutputProtocol

extension UserDetailPresenter: UserDetailInteractorOutputProtocol {
    func didFetchCleanerDetail(_ cleaner: CleanerResponseModel) {
        view?.hideLoading()
        let item = UserDetailItem(from: cleaner)
        currentItem = item
        view?.displayDetail(item, reviews: mockReviews)
    }

    func didFailFetchingDetail(with message: String) {
        view?.hideLoading()
        view?.showAlert(with: .init(title: "Hata", message: message))
    }
}
