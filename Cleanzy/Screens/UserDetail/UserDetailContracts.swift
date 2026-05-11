//
//  UserDetailContracts.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - UserDetailViewProtocol

protocol UserDetailViewProtocol: BaseViewProtocol, AnyObject {
    var presenter: UserDetailPresenterProtocol! { get set }

    func displayDetail(_ item: UserDetailItem, reviews: [UserDetailReviewItem])
    func appendReviews(_ reviews: [UserDetailReviewItem])
    func updateFavoriteButton(isFavorited: Bool)
}

// MARK: - UserDetailInteractorInputProtocol

protocol UserDetailInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: UserDetailInteractorOutputProtocol? { get set }

    func fetchCleanerDetail(cleanerID: Int)
    func fetchReviews(cleanerID: Int)
    func createOrGetConversation(participantUserID: Int)
}

// MARK: - UserDetailInteractorOutputProtocol

protocol UserDetailInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject {
    func didFetchCleanerDetail(_ cleaner: CleanerResponseModel)
    func didFetchReviews(_ reviews: [UserDetailReviewItem])
    func didFailFetchingDetail(with message: String)
    func didCreateOrGetConversation(_ conversation: ConversationResponseModel)
    func didFailCreatingConversation(with message: String)
}

// MARK: - UserDetailPresenterProtocol

protocol UserDetailPresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: UserDetailViewProtocol? { get set }
    var interactor: UserDetailInteractorInputProtocol? { get set }
    var router: UserDetailRouterProtocol? { get set }

    func didTapCreateMeet()
    func didTapFavorite()
    func didTapChat()
}

// MARK: - UserDetailRouterProtocol

protocol UserDetailRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: UserDetailPresenterProtocol? { get set }

    func navigateBack()
    func navigateToCreateMeet(cleanerID: Int, hourlyRate: Double, cleanerName: String)
    func navigateToChat(with chatItem: ChatItem)
}

// MARK: - UserDetailBuilderProtocol

protocol UserDetailBuilderProtocol: AnyObject {
    static func createModule(with cleanerID: Int) -> UserDetailViewController
}
