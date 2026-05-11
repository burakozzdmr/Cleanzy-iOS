//
//  PaymentMethodsContracts.swift
//  Cleanzy
//

import Foundation

// MARK: - PaymentMethodsViewProtocol

protocol PaymentMethodsViewProtocol: BaseViewProtocol, AnyObject {
    var presenter: PaymentMethodsPresenterProtocol! { get set }

    func displayCards(_ cards: [PaymentCardItem])
}

// MARK: - PaymentMethodsInteractorInputProtocol

protocol PaymentMethodsInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: PaymentMethodsInteractorOutputProtocol? { get set }

    func fetchCards()
    func deleteCard(at index: Int)
}

// MARK: - PaymentMethodsInteractorOutputProtocol

protocol PaymentMethodsInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject {
    func didFetchCards(_ cards: [PaymentCardItem])
    func didDeleteCard(at index: Int)
}

// MARK: - PaymentMethodsPresenterProtocol

protocol PaymentMethodsPresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: PaymentMethodsViewProtocol? { get set }
    var interactor: PaymentMethodsInteractorInputProtocol? { get set }
    var router: PaymentMethodsRouterProtocol? { get set }

    func didTapAddCard()
    func didTapDelete(at index: Int)
}

// MARK: - PaymentMethodsRouterProtocol

protocol PaymentMethodsRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: PaymentMethodsPresenterProtocol? { get set }

    func presentAddCard(completion: @escaping (PaymentCardItem) -> Void)
}

// MARK: - PaymentMethodsBuilderProtocol

protocol PaymentMethodsBuilderProtocol: AnyObject {
    static func createModule() -> PaymentMethodsViewController
}
