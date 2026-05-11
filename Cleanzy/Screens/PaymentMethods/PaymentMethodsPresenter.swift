//
//  PaymentMethodsPresenter.swift
//  Cleanzy
//

import Foundation

// MARK: - PaymentMethodsPresenter

final class PaymentMethodsPresenter {
    weak var view: PaymentMethodsViewProtocol?
    var interactor: PaymentMethodsInteractorInputProtocol?
    var router: PaymentMethodsRouterProtocol?

    private var cards: [PaymentCardItem] = []
}

// MARK: - PaymentMethodsPresenterProtocol

extension PaymentMethodsPresenter: PaymentMethodsPresenterProtocol {
    func viewDidLoad() {
        interactor?.fetchCards()
    }

    func didTapAddCard() {
        router?.presentAddCard { [weak self] newCard in
            self?.cards.append(newCard)
            self?.view?.displayCards(self?.cards ?? [])
        }
    }

    func didTapDelete(at index: Int) {
        interactor?.deleteCard(at: index)
    }
}

// MARK: - PaymentMethodsInteractorOutputProtocol

extension PaymentMethodsPresenter: PaymentMethodsInteractorOutputProtocol {
    func didFetchCards(_ cards: [PaymentCardItem]) {
        self.cards = cards
        view?.displayCards(cards)
    }

    func didDeleteCard(at index: Int) {
        cards.remove(at: index)
        view?.displayCards(cards)
    }
}
