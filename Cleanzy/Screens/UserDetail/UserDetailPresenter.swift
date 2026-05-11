//
//  UserDetailPresenter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Combine
import Foundation

// MARK: - UserDetailPresenter

final class UserDetailPresenter {
    weak var view: UserDetailViewProtocol?
    var interactor: UserDetailInteractorInputProtocol?
    var router: UserDetailRouterProtocol?

    private let cleanerID: Int
    private var currentItem: UserDetailItem?
    private var cancellables: Set<AnyCancellable> = .init()

    init(cleanerID: Int) {
        self.cleanerID = cleanerID
    }
}

// MARK: - UserDetailPresenterProtocol

extension UserDetailPresenter: UserDetailPresenterProtocol {
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchCleanerDetail(cleanerID: cleanerID)
    }

    func didTapCreateMeet() {
        let hourlyRate   = currentItem?.hourlyRate ?? 0
        let cleanerName  = currentItem?.fullName ?? ""
        router?.navigateToCreateMeet(cleanerID: cleanerID, hourlyRate: hourlyRate, cleanerName: cleanerName)
    }

    func didTapChat() {
        guard let item = currentItem else { return }
        interactor?.createOrGetConversation(participantUserID: item.id)
    }

    func didTapFavorite() {
        guard let item = currentItem else { return }
        let favoriteItem = FavoriteItem(from: item)

        FavoritesManager.shared.toggleFavorite(favoriteItem)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.view?.showAlert(with: .init(title: "Hata", message: error.networkErrorMessage))
                }
            } receiveValue: { [weak self] isFavorited in
                self?.view?.updateFavoriteButton(isFavorited: isFavorited)
                let title   = isFavorited ? "Favorilere Eklendi" : "Favorilerden Çıkarıldı"
                let message = isFavorited
                    ? "\(item.fullName) favorilerinize eklendi."
                    : "\(item.fullName) favorilerinizden çıkarıldı."
                self?.view?.showAlert(with: .init(title: title, message: message))
            }
            .store(in: &cancellables)
    }
}

// MARK: - UserDetailInteractorOutputProtocol

extension UserDetailPresenter: UserDetailInteractorOutputProtocol {
    func didFetchCleanerDetail(_ cleaner: CleanerResponseModel) {
        view?.hideLoading()
        let item = UserDetailItem(from: cleaner)
        currentItem = item
        view?.displayDetail(item, reviews: [])
        let isFavorited = FavoritesManager.shared.isFavorite(cleanerID: item.id)
        view?.updateFavoriteButton(isFavorited: isFavorited)
        // Also fetch reviews
        interactor?.fetchReviews(cleanerID: cleanerID)
    }

    func didFetchReviews(_ reviews: [UserDetailReviewItem]) {
        view?.appendReviews(reviews)
    }

    func didFailFetchingDetail(with message: String) {
        view?.hideLoading()
        view?.showAlert(with: .init(title: "Hata", message: message))
    }

    func didCreateOrGetConversation(_ conversation: ConversationResponseModel) {
        view?.hideLoading()
        let chatItem = ChatItem(from: conversation)
        router?.navigateToChat(with: chatItem)
    }

    func didFailCreatingConversation(with message: String) {
        view?.hideLoading()
        view?.showAlert(with: .init(title: "Hata", message: message))
    }
}
